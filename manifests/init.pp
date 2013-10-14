class postfix {
  include postfix::params, postfix::install, postfix::config, postfix::service
}

class postfix::install {
  package { [ "postfix", "mailx" ]:
    ensure => present,
  }
}

class postfix::config {
  $require = Class["postfix::install"]

  File {
    owner => $postfix::params::owner,
    group => $postfix::params::group,
    mode  => '0644',
  }

  # this master file breaks cyrus/etc. on rhel4
  file { "/etc/postfix/master.cf":
    ensure  => present,
    source  => "puppet:///modules/postfix/$postfix::params::postfix_master_src",
    notify  => Class["postfix::service"],
  }

  file { "/etc/postfix/main.cf":
    ensure  => present,
    content => template($postfix::params::postfix_main_erb),
    notify  => Class["postfix::service"],
  }
}

class postfix::service {
  service { "postfix":
    ensure      => running,
    hasstatus   => true,
    hasrestart  => true,
    enable      => true,
    require     => Class["postfix::config"],
  }
}

class postfix::params {
  case $operatingsystem {
    /(RedHat|CentOS|Scientific)/: {
      $postfix_owner    = "postfix"
      $postfix_group    = "postfix"
      case $lsbmajdistrelease {
        5: {
          $postfix_main_erb = "postfix/main.cf.el5.erb"
          $postfix_master_src = 'master.cf'
        }
        6: {
          $postfix_main_erb = "postfix/main.cf.el6.erb"
          $postfix_master_src = 'master.cf.el6'
        }
        default: {
          $postfix_main_erb = "postfix/main.cf.el5.erb"
          $postfix_master_src = 'master.cf'
        }
      }
    }
    Gentoo: {
      $postfix_master_src = 'master.cf'
      $postfix_owner    = "root"
      $postfix_group    = "root"
      $postfix_main_erb = "postfix/main.cf.gentoo.10.0.erb"
    }
    default: {
      $postfix_master_src = 'master.cf'
      $postfix_owner    = "postfix"
      $postfix_group    = "postfix"
      $postfix_main_erb = "postfix/main.cf.el5.erb"
    }
  }
}

class postfix::params {
  case $::osfamily {
    'RedHat': {
      $postfix_owner = 'postfix'
      $postfix_group = 'postfix'

      case $::operatingsystemmajrelease {
        5: {
          $postfix_main_erb   = 'postfix/main.cf.el5.erb'
          $postfix_master_src = 'master.cf'
        }
        6: {
          $postfix_main_erb   = 'postfix/main.cf.el6.erb'
          $postfix_master_src = 'master.cf.el6'
        }
        default: {
          $postfix_main_erb   = 'postfix/main.cf.el5.erb'
          $postfix_master_src = 'master.cf'
        }
      }
    }
    'Gentoo': {
      $postfix_master_src = 'master.cf'
      $postfix_owner      = 'root'
      $postfix_group      = 'root'
      $postfix_main_erb   = 'postfix/main.cf.gentoo.10.0.erb'
    }
    default: {
      $postfix_master_src = 'master.cf'
      $postfix_owner      = 'postfix'
      $postfix_group      = 'postfix'
      $postfix_main_erb   = 'postfix/main.cf.el5.erb'
    }
  }
}

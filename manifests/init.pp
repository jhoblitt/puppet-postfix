class postfix {
  include ::postfix::params

  package { [ 'postfix', 'mailx' ]:
    ensure => present,
  } ->
  # this master file breaks cyrus/etc. on rhel4
  file { '/etc/postfix/master.cf':
    ensure => present,
    owner  => $::postfix::params::owner,
    group  => $::postfix::params::group,
    mode   => '0644',
    source => "puppet:///modules/postfix/${::postfix::params::postfix_master_src}",
    notify => Service['postfix'],
  } ->
  file { '/etc/postfix/main.cf':
    ensure  => present,
    owner   => $::postfix::params::owner,
    group   => $::postfix::params::group,
    mode    => '0644',
    content => template($::postfix::params::postfix_main_erb),
    notify  => Service['postfix'],
  } ->
  service { 'postfix':
    ensure     => running,
    hasstatus  => true,
    hasrestart => true,
    enable     => true,
  }
}

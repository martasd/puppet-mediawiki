# Class: mediawiki::mysql-server
#
# Configures mysql server.
#
# Parameters:
#
# [*package_ensure*]
#
# Actions:
#
# Requires:
#
# None
#
# Sample Usage:
#
class mediawiki::mysql-server (
  $package_ensure = 'present'
  ) {

  package { 'mysql-server':
    name   => $mediawiki::params::mysql_server,
    ensure => $package_ensure,
  }

  service { 'mysqld':
    name    => $mediawiki::params::mysql_service,
    ensure  => running,
    enable  => true,
    require => Package['mysql-server'],
  }
}
 

# Class: mediawiki::apache
#
# Configures apache.
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
# mediawiki::apache { 'apache':
#   $package_ensure = 'present'
#   }

class mediawiki::apache (
  $package_ensure = 'present'
  ) {

  package { 'apache':
    name   => $mediawiki::params::apache_server,
    ensure => $package_ensure,
  }

  service { 'apache':
    name    => $mediawiki::params::apache_service,
    ensure  => running.
    enable = true,
    hasrestart => true,
    hasstatus => true,
    require => Package['apache'],
  }
}
     
   

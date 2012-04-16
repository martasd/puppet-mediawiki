# Class: mediawiki::php
#
# Configures php.
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
# mediawiki::php {
#   $package_ensure => 'present'
# }
#
class mediawiki::php (
  $package_ensure = 'present'
  ) {

  package { 'php':
    name   => $mediawiki::params::php,
    ensure => $package_ensure,
  }
}

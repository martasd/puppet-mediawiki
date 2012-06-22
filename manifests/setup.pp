# Class: mediawiki::setup
#
# This class includes all resources regarding installation and configuration
# that needs to be performed exactly once and is therefore not mediawiki
# instance specific.
#
# === Parameters:
#
# [*package_ensure*] - state of the package
#
# === Examples
#
# include mediawiki::setup
#
# === Authors
#
# Martin Dluhos <martin@gnu.org>
#
# === Copyright:
#
# Copyright 2012 Martin Dluhos
#
class mediawiki::setup ($package_ensure = 'latest') {

  class { 'apache': }

  package { 'php':
    ensure => $package_ensure,
  }

  package { 'php5-mysql':
    ensure => $package_ensure,
  }

  package { 'medawiki':
    ensure => $package_ensure,
  }

  package { 'medawiki-extensions':
    ensure => $package_ensure,
  }

  class { 'memcached':
    max_memory => $max_memory,
  }
}

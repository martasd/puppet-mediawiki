# === Class: mediawiki::params
#
#  The mediawiki configuration settings idiosyncratic to different operating
#  systems.
#
# === Parameters
#
# None
#
# === Examples
#
# None
#
# === Authors
#
# Martin Dluhos <martin@gnu.org>
#
# === Copyright
#
# Copyright 2012 Martin Dluhos
#
class mediawiki::params {

  case $::operatingsystem {
    redhat: {
    }
    debian: {
    }
    ubuntu: {
      $packages = ['php', 'php5-mysql', 'mediawiki', 'mediawiki-extensions']
      $mediawiki_root = '/var/lib/mediawiki'
    }
    default: {
      fail("Module ${module_name} is not supported on ${::operatingsystem}")
    }
  }
}

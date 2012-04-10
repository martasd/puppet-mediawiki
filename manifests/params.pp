# Class: mediawiki::params
#
#  The mediawiki configuration settings.
#
# Parameters:
#
#  None
#
# Actions:
#
# Requires:
#
# Sample Usage:
class mediawiki::params {

  case $::operatingsystem {
    redhat: {
      $package_name = 'mediawiki'
      $mediawiki_root = '/var/www/html'
    }
    debian: {
      $package_name = 'mediawiki'
      $mediawiki_root = '/var/lib/mediawiki'
    }
    ubuntu: {
      $package_name = 'mediawiki'
      $mediawiki_root = '/var/lib/mediawiki'
    }
    default: {
      fail("Module ${module_name} is not supported on ${::operatingsystem}")
    }
  }
}

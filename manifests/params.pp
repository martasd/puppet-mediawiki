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
      $conf_dir = '/etc/mediawiki'
      $apache_dir = '/var/lib/mediawiki'
      $installation_files = ['api.php', 'config', 'extensions', 'img_auth.php',
                             'includes', 'index.php', 'install-utils.inc',
                             'languages', 'maintenance', 'opensearch_desc.php',
                             'profileinfo.php', 'redirect.php',
                             'redirect.phtml', 'skins', 'StartProfiler.php',
                             'thumb.php', 'trackback.php', 'wiki.phtml']
    }
    default: {
      fail("Module ${module_name} is not supported on ${::operatingsystem}")
    }
  }
}

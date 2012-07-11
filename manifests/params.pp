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
      $packages           = ['php5', 'php5-mysql',
                             'mediawiki', 'mediawiki-extensions']
      $conf_dir           = '/etc/mediawiki'
      $instance_root_dir  = '/var/www'
      $apache_daemon      = '/usr/sbin/apache2'
      $installation_files = ['api.php', 'config', 'extensions','img_auth.php',
                             'includes', 'index.php', 'load.php', 'languages',
                             'maintenance', 'mw-config', 'opensearch_desc.php',
                             'profileinfo.php', 'redirect.php', 'redirect.phtml',
                             'resources', 'skins', 'thumb_handler.php',
                             'thumb.php', 'wiki.phtml']
    }
    ubuntu: {
      $packages           = ['php5', 'php5-mysql',
                             'mediawiki', 'mediawiki-extensions']
      $conf_dir           = '/etc/mediawiki'
      $instance_root_dir  = '/var/www'
      $apache_daemon      = '/usr/sbin/apache2'
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

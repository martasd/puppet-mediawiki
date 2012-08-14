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

  $packages           = ['php5', 'php5-mysql',
                         'mediawiki']
  $install_dir        = '/usr/share/mediawiki'
  $conf_dir           = '/etc/mediawiki'
  $apache_daemon      = '/usr/sbin/apache2'
  $installation_files = $::operatingsystem ? {
    debian            => ['api.php', 'config', 'extensions','img_auth.php',
                          'includes', 'index.php', 'load.php', 'languages',
                          'maintenance', 'mw-config', 'opensearch_desc.php',
                          'profileinfo.php', 'redirect.php', 'redirect.phtml',
                          'resources', 'skins', 'thumb_handler.php',
                          'thumb.php', 'wiki.phtml'],
    ubuntu            => ['api.php', 'config', 'extensions', 'img_auth.php',
                          'includes', 'index.php', 'install-utils.inc',
                          'languages', 'maintenance', 'opensearch_desc.php',
                          'profileinfo.php', 'redirect.php',
                          'redirect.phtml', 'skins', 'StartProfiler.php',
                          'thumb.php', 'trackback.php', 'wiki.phtml'],
    /(redhat|centos)/ => ['api.php', 'config', 'extensions', 'img_auth.php',
                          'includes', 'index.php', 'install-utils.inc',
                          'languages', 'maintenance', 'opensearch_desc.php',
                          'profileinfo.php', 'redirect.php',
                          'redirect.phtml', 'skins', 'StartProfiler.php',
                          'thumb.php', 'trackback.php', 'wiki.phtml'],
    default           => fail("Module ${module_name} is not supported on ${::operatingsystem}"),
  }
}

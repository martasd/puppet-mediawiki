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

  $packages           = ['php5', 'php5-mysql', 'wget']
  $web_dir            = '/var/www'
  $doc_root           = "${web_dir}/wikis"
  $tarball_url        = 'http://download.wikimedia.org/mediawiki/1.19/mediawiki-1.19.1.tar.gz'
  $conf_dir           = '/etc/mediawiki'
  $apache_daemon      = '/usr/sbin/apache2'
  $installation_files = $::operatingsystem ? {
    /(?i)(debian|ubuntu)/ => ['api.php',
                              'api.php5',
                              'bin',
                              'docs',
                              'extensions',
                              'img_auth.php',
                              'img_auth.php5',
                              'includes',
                              'index.php',
                              'index.php5',
                              'languages',
                              'load.php',
                              'load.php5',
                              'maintenance',
                              'mw-config',
                              'opensearch_desc.php',
                              'opensearch_desc.php5',
                              'profileinfo.php',
                              'redirect.php',
                              'redirect.php5',
                              'redirect.phtml',
                              'resources',
                              'serialized',
                              'skins',
                              'StartProfiler.sample',
                              'tests',
                              'thumb_handler.php',
                              'thumb_handler.php5',
                              'thumb.php',
                              'thumb.php5',
                              'wiki.phtml'],
    /(?i)(redhat|centos)/ => ['api.php', 'config', 'extensions', 'img_auth.php',
                              'includes', 'index.php', 'install-utils.inc',
                              'languages', 'maintenance', 'opensearch_desc.php',
                              'profileinfo.php', 'redirect.php',
                              'redirect.phtml', 'skins', 'StartProfiler.php',
                              'thumb.php', 'trackback.php', 'wiki.phtml'],
    default               => fail("Module ${module_name} is not supported on ${::operatingsystem}"),
  }
}

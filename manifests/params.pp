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

  $major              = '1.29'
  $minor              = '1'
  $tarball_url        = "http://releases.wikimedia.org/mediawiki/$major/mediawiki-$major.$minor.tar.gz"
  $conf_dir           = '/etc/mediawiki'
  $apache_daemon      = '/usr/sbin/apache2'
  $installation_files = ['api.php',
                         'api.php5',
                         'autoload.php',
			 'composer.json',
                         'docs',
                         'extensions',
                         'Gruntfile.js',
                         'img_auth.php',
                         'img_auth.php5',
                         'includes',
                         'index.php',
                         'index.php5',
                         'jsduck.json',
                         'languages',
                         'load.php',
                         'load.php5',
                         'maintenance',
                         'mw-config',
                         'opensearch_desc.php',
                         'opensearch_desc.php5',
                         'phpcs.xml',
                         'profileinfo.php',
                         'profileinfo.php5',
                         'Rakefile',
                         'resources',
                         'serialized',
                         'skins',
                         'StartProfiler.sample',
                         'tests',
                         'thumb_handler.php',
                         'thumb_handler.php5',
                         'thumb.php',
                         'thumb.php5',
                         'vendor',
                         'wiki.phtml']
  
  case $::operatingsystem {
    redhat, centos:  {
      $web_dir            = '/var/www/html'
      $doc_root           = "${web_dir}/wikis"
      $packages           = ['php-gd', 'php-mysql', 'php-xml', 'php-mbstring', 'wget']
    }
    debian:  {
      $web_dir            = '/var/www'
      $doc_root           = "${web_dir}/wikis"
      $packages           = ['php', 'php-mysql', 'php-xml', 'php-mbstring', 'wget']
    }
    ubuntu:  {
      $web_dir            = '/var/www'
      $doc_root           = "${web_dir}/wikis"
      $packages           = ['php5', 'php5-mysql', 'php-xml', 'php-mbstring', 'wget']
    }
    default: {
      fail("Module ${module_name} is not supported on ${::operatingsystem}")
    }
  }
}

# Class: mediawiki
#
# This class includes all resources regarding installation and configuration
# that needs to be performed exactly once and is therefore not mediawiki
# instance specific.
#
# === Parameters
#
# [*server_name*]      - the host name of the server
# [*admin_email*]      - email address Apache will display when rendering error page
# [*db_root_password*] - password for mysql root user
# [*doc_root*]         - the DocumentRoot directory used by Apache
# [*package_ensure*]   - state of the package
# [*max_memory*]       - a memcached memory limit
#
# === Examples
#
# class { 'mediawiki':
#   server_name      => 'www.example.com',
#   admin_email      => 'admin@puppetlabs.com',
#   db_root_password => 'really_really_long_password',
#   max_memory       => '1024'
# }
#
# mediawiki::instance { 'my_wiki1':
#   db_name     => 'wiki1_user',
#   db_password => 'really_long_password',
# }
#
## === Authors
#
# Martin Dluhos <martin@gnu.org>
#
# === Copyright
#
# Copyright 2012 Martin Dluhos
#
class mediawiki (
  $server_name,
  $admin_email,
  $db_root_password,
  $doc_root       = '/var/www/wikis',
  $package_ensure = 'latest',
  $max_memory     = '2048'
  ) {

  include mediawiki::params

  Class['mysql::server'] -> Class['mediawiki']
  Class['mysql::config'] -> Class['mediawiki']
  
  class { 'apache': }
  class { 'apache::php': }
  
  # Manages the mysql server package and service by default
  class { 'mysql::server':
    config_hash => { 'root_password' => $db_root_password },
  }

  package { $mediawiki::params::packages:
    ensure  => $package_ensure,
  }
  
  # Not including problematic memcached module
  #class { 'memcached':
  #  max_memory => $max_memory,
  #}

  # Make sure the directories and files common for all instances are included
  file { 'mediawiki_conf_dir':
    ensure  => 'directory',
    path    => $mediawiki::params::conf_dir,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    require => Package[$mediawiki::params::packages],
  }
}

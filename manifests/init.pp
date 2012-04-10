# Class: mediawiki
#
# This module manages mediawiki.
#
# Parameters:
#
# [*package_ensure*]
# [*admin*]
# [*servername*]
# [*serveralias*]
# [*db_name*]
# [*db_user*]
# [*db_password*]
# [*memory*]
# [*ip*]
# [*port*]
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class mediawiki (
    $package_ensure = 'latest',
    $admin,
    $servername = $name,
    $serveralias = $name,
    $db_name = $name,
    $db_user = 'mediawiki',
    $db_password = 'mediawiki',
    $memory = 2048,
    $ip,
    $port = 80) {

  package { 'mediawiki':
    name => $mediawiki::params::package_name,
    ensure => $package_ensure,
  }

  # ghoneycutt's apache module needs to be extended and improved
  class { 'apache:php': }

  class { 'mysql::server': }

  # Create a MySQL database
  mysql::db  { $db_name:
    user => $db_user,
         password => $db_password,
         host => $::hostname
  }


  class { 'memcached': 
    max_memory => $memory
  }

  class { 'authconfig': }


  file { 'wikis':
            path    => '${mediawiki_root}/wikis',
            owner   => 'root',
            group   => 'root',
            ensure  => directory,
            mode    => 0755,
            require => Package['mediawiki'];
  }

  file { 'mywiki':
            path    => '${mediawiki_root}/wikis/${name}',
            owner   => 'root',
            group   => 'root',
            ensure  => directory,
            mode    => 0755,
            require => File['wikis'];
  }

  file { 'skins':
            path    => '${mediawiki_root}/wikis/${name}/skins',
            owner   => 'www-data',
            group   => 'www-data',
            ensure  => directory,
            mode    => 0755,
            require => File['mywiki'];
  }

  file { 'config_file':
            path    => '${mediawiki_root}/wikis/${name}/index.php',
            owner   => 'www-data',
            group   => 'www-data',
            content => template('index.php.erb'),
            mode    => 0755;
  }

  # Add other files and directories
}

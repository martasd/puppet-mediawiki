# Class: mediawiki
#
# This module manages a multi-tenant mediawiki installation.
#
# Parameters:
#
# [*package_ensure*]
# [*db_name*]
# [*db_user*]
# [*db_password*]
# [*memory*]
#
# To be implemented:
# [*ip*]
# [*port*]
#
# Actions:
#
# Requires:
#
# None
#
# Sample Usage:
#
class mediawiki (
  $package_ensure = 'latest',
  $db_name,
  $db_user,
  $db_password = 'my_password',
  $memory = 2048,
  ) {

  package { 'mediawiki':
    name => $mediawiki::params::package_name,
    ensure => $package_ensure,
  }

  class { 'mediawiki::apache': }

  class { 'mediawiki::php': }
  
  class { 'mediawiki::mysql_server': }

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

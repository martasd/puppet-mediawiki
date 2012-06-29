# == Define: mediawiki::instance
#
# This module manages a multi-tenant mediawiki installation.
#
# === Parameters
#
# [*db_name*]          - name of the mediawiki instance mysql database
# [*db_user*]          - name of the mysql database user
# [*db_password*]      - password for the mysql database user
# [*status*]           - the current status of the wiki instance
#                      - options: present, enabled, disabled, absent
#
# === Examples
#
# class { 'mediawiki':
#   db_root_password = 'really_really_long_password',
#   max_memory       = '1024'
# }
#
# mediawiki::instance { 'my_wiki1':
#   db_name     = 'wiki1_user',
#   db_password = 'really_long_password',
#   status      = 'present'
# }
#
# === Authors
#
# Martin Dluhos <martin@gnu.org>
#
# === Copyright
#
# Copyright 2012 Martin Dluhos
#
define mediawiki::instance (
  $db_password,
  $db_name = $name,
  $db_user = 'mediawiki_user',
  $status = 'present'
  ) {

  include mediawiki::params

  case $status {
    present, default: {

      # mediawiki needs to be installed before a particular instance is created
      Class['mediawiki'] -> Mediawiki::Instance[$name]

      # Create a database for this mediawiki instance
      include mysql::db
      mysql::db { $db_name:
        user     => $db_user,
        password => $db_password,
        host     => 'localhost',
        grant    => ['all'],
      }

      # Figure out how to improve db security (manually done by
      # mysql_secure_installation)

      # Capture further configuration done through manually through GUI and the
      # filesystem specific to an instance
      file { "${mediawiki::params::conf_dir}/${name}":
        ensure   => directory,
        owner    => 'root',
        group    => 'root',
        mode     => '0755',
        require  => File['configuration_dir'],
      }

      # Mediawiki configuration file for this instance
      file { "${mediawiki::params::conf_dir}/${name}/LocalSettings.php":
        owner    => 'www-data',
        group    => 'www-data',
        content  => template('mediawiki/LocalSettings.php.erb'),
        mode     => '0700',
        require  => File["${mediawiki::params::conf_dir}/${name}"],
      }

      # Each instance needs a separate folder to upload images
      file { "${mediawiki::params::conf_dir}/${name}/images":
        ensure   => directory,
        owner    => 'root',
        group    => 'www-data',
        mode     => '0664',
        require  => File["${mediawiki::params::conf_dir}/${name}"],
      }

      file { "${mediawiki::params::conf_dir}/${name}/${installation_files}":
        ensure   => link,
        owner    => 'root',
        group    => 'root',
        mode     => '0755',
        require  => File["${mediawiki::params::conf_dir}/${name}"],
      }

      # Ensure a directory for Apache vhost
      file { "${mediawiki::params::apache_dir}/${name}":
        ensure   => link,
        owner    => 'root',
        group    => 'root',
        target   => "${mediawiki::params::conf_dir}/${name}",
      }

      # Each instance has a separate vhost file
      file { "/etc/apache2/sites-available/${name}_vhost":
        owner    => 'www-data',
        group    => 'www-data',
        content  => template('/mediawiki/instance_vhost.erb'),
        require  => File["${mediawiki::params::apache_dir}/${name}"],
      }
    }

    enabled: {

      file { "/etc/apache2/sites-enabled/${name}_vhost":
        ensure   => link,
        owner    => 'www-data',
        group    => 'www-data',
        target   => File["/etc/apache2/sites-available/${name}_vhost"],
      }

      # Start Apache if it is not running
    }

    disabled: {

      # Disable Apache if it is enabled
    }

    absent: {

      # Remove the instance if it is present
    }
}

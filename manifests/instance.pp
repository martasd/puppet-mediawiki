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
#   db_password = 'really_long_password',
#   db_name     = 'wiki1',
#   db_user     = 'wiki1_user',
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
  $db_user = 'wiki1_user',
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

      # Specify the state of files which make up the wiki instance
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

      file { "${mediawiki::params::conf_dir}\
              /${name}/${mediawki::params::installation_files}":
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
        notify   => Service[$mediawiki::params::apache],
      }
    }

    enabled: {

      file { "/etc/apache2/sites-enabled/${name}_vhost":
        ensure   => link,
        owner    => 'www-data',
        group    => 'www-data',
        target   => File["/etc/apache2/sites-available/${name}_vhost"],
      }

      service: { $mediawiki::params::apache:
        ensure     => 'running',
        hasstatus  => true,
        hasrestart => true,
        enable     => true,
        require    => File["/etc/apache2/sites-enabled/${name}_vhost"],
      }
    }

    disabled: {

      file { "/etc/apache2/sites-enabled/${name}_vhost":
        ensure   => absent,
        owner    => 'www-data',
        group    => 'www-data',
      }

      service: { $mediawiki::params::apache:
        ensure     => 'stopped',
        hasstatus  => true,
        hasrestart => true,
        enable     => false,
      }
    }

    absent: {

      # Remove the instance if it is present
      file { "${mediawiki::params::conf_dir}/${name}":
        ensure  => absent,
        recurse => true,
      }

      file { "/etc/apache2/sites-available/${name}_vhost":
        ensure  => absent,
      }

      # Delete the mysql database
      # NOTE: Need to fix puppet-mysql to allow to specify the option
    }
  }
}

# == Define: mediawiki::instance
#
# This defined type allows the user to create a mediawiki instance.
#
# === Parameters
#
# [*db_name*]     - name of the mediawiki instance mysql database
# [*db_user*]     - name of the mysql database user
# [*db_password*] - password for the mysql database user
# [*port*]        - port on mediawiki web server
# [*status*]      - the current status of the wiki instance
#                 - options: present, absent, deleted
#
# === Examples
#
# class { 'mediawiki':
#   admin_email      => 'admin@puppetlabs.com',
#   db_root_password => 'really_really_long_password',
#   max_memory       => '1024'
# }
#
# mediawiki::instance { 'my_wiki1':
#   db_password => 'really_long_password',
#   db_name     => 'wiki1',
#   db_user     => 'wiki1_user',
#   port        => '80',
#   status      => 'present'
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
  $db_user = "${name}_user",
  $port    = '80',
  $status  = 'present'
  ) {
  
  validate_re($status, [ '^present$', '^absent$', '^deleted$' ],
  "${status} is not supported for status.
  Allowed values are 'present', 'absent', and 'deleted'.")

  include mediawiki::params

  # mediawiki needs to be installed before a particular instance is created
  Class['mediawiki'] -> Mediawiki::Instance[$name]

  # Make the configuration file more readable
  $admin_email             = $mediawiki::admin_email
  $db_root_password        = $mediawiki::db_root_password
  $mediawiki_conf_dir      = $mediawiki::params::conf_dir
  $mediawiki_install_dir   = $mediawiki::params::install_dir
  $mediawiki_install_files = $mediawiki::params::installation_files
  $instance_root_dir       = $mediawiki::params::instance_root_dir
  $apache_daemon           = $mediawiki::params::apache_daemon

  # Figure out how to improve db security (manually done by
  # mysql_secure_installation)
  case $status {
    'present', 'absent': {
      
      exec { 'mediawiki_install_script':
        cwd         => "${mediawiki_install_dir}/maintenance",
        # unless      => "/usr/bin/test -f ${mediawiki_conf_dir}/${name}/LocalSettings.php",
        creates     => "${mediawiki_conf_dir}/${name}/LocalSettings.php",
        command     => "/usr/bin/php install.php                  \
                        --pass puppet                             \
                        --email ${admin_email}                    \
                        --scriptpath /${name}                     \
                        --dbtype mysql                            \
                        --dbserver localhost                      \
                        --installdbuser root                      \
                        --installdbpass ${db_root_password}       \
                        --dbname ${db_name}                       \
                        --dbuser ${db_user}                       \
                        --dbpass ${db_password}                   \
                        --confpath ${mediawiki_conf_dir}/${name}  \
                        --lang en                                 \
                        ${name}                                   \
                        admin",
        subscribe   => File["${mediawiki_conf_dir}/${name}/images"],
      }
  
      # MediaWiki instance directory
      file { "${mediawiki_conf_dir}/${name}":
        ensure   => directory,
        owner    => 'root',
        group    => 'root',
        mode     => '0755',
        require  => File["${mediawiki_conf_dir}"],
      }

      # Each instance needs a separate folder to upload images
      file { "${mediawiki_conf_dir}/${name}/images":
        ensure   => directory,
        owner    => 'root',
        group    => 'www-data',
        mode     => '0664',
        require  => File["${mediawiki_conf_dir}/${name}"],
      }

      # Ensure that mediawiki configuration files are included in each instance.
      mediawiki::files { $mediawiki_install_files:
        instance_name => $name,
      }

      # Symlink for the mediawiki instance directory
      file { "${instance_root_dir}/${name}":
        ensure   => link,
        owner    => 'root',
        group    => 'root',
        target   => "${mediawiki_conf_dir}/${name}",
        require  => File["${mediawiki_conf_dir}/${name}/images"],
      }
     
      # Each instance has a separate vhost configuration
      apache::vhost { $name:
        port         => $port,
        docroot      => $instance_root_dir,
        serveradmin  => $admin_email,
        template     => 'mediawiki/instance_vhost.erb',
        ensure       => $status,
      }
    }
    'deleted': {
      
      # Remove the MediaWiki instance directory if it is present
      file { "${mediawiki_conf_dir}/${name}":
        ensure  => absent,
        recurse => true,
      }

      # Remove the symlink for the mediawiki instance directory
      file { "${instance_root_dir}/${name}":
        ensure   => absent,
        recurse  => true,
      }

      mysql::db { $db_name:
        user     => $db_user,
        password => $db_password,
        host     => 'localhost',
        grant    => ['all'],
        ensure   => 'absent',
      }

      apache::vhost { $name:
        port         => $port,
        docroot      => $instance_root_dir,
        serveradmin  => $admin_email,
        template     => 'mediawiki/instance_vhost.erb',
        ensure       => 'absent',
      } 
    }
  }
}

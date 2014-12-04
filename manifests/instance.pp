# == Define: mediawiki::instance
#
# This defined type allows the user to create a mediawiki instance.
#
# === Parameters
#
# [*db_name*]        - name of the mediawiki instance mysql database
# [*db_user*]        - name of the mysql database user
# [*db_password*]    - password for the mysql database user
# [*ip*]             - ip address of the mediawiki web server
# [*port*]           - port on mediawiki web server
# [*server_aliases*] - an array of mediawiki web server aliases
# [*ensure*]         - the current status of the wiki instance
#                    - options: present, absent, deleted
# [*vhost_type*]     - Whether the wiki will be defined by the name of the
#                      host or its path
#                    - options: host, path
# [*server_name*]    - Unique server name to use for host-based wikis
# [*admin_name*]     - name of the wiki's administrator (admin by default)
# [*admin_password*] - password for the wiki's administrator (puppet by default)
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
#   ensure      => 'present'
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
  $db_name        = $name,
  $db_user        = "${name}_user",
  $ip             = '*',
  $port           = '80',
  $server_aliases = '',
  $ensure         = 'present',
  $vhost_type     = 'path',
  $server_name    = $mediawiki::server_name,
  $admin_name     = 'admin',
  $admin_password = 'puppet',
  ) {
  
  validate_re($ensure, '^(present|absent|deleted)$',
  "${ensure} is not supported for ensure.
  Allowed values are 'present', 'absent', and 'deleted'.")

  include mediawiki::params

  # MediaWiki needs to be installed before a particular instance is created
  Class['mediawiki'] -> Mediawiki::Instance[$name]

  # Make the configuration file more readable
  $admin_email             = $mediawiki::admin_email
  $db_root_password        = $mediawiki::db_root_password
  $doc_root                = $mediawiki::doc_root
  $mediawiki_install_path  = $mediawiki::mediawiki_install_path
  $mediawiki_conf_dir      = $mediawiki::params::conf_dir
  $mediawiki_install_files = $mediawiki::params::installation_files
  $apache_daemon           = $mediawiki::params::apache_daemon

  # Configure according to whether the wiki instance will be accessed
  # through a unique host name or through a unique path
  $vhost_root = $vhost_type ? {
    'path' => $doc_root,
    'host' => "$doc_root/$name",
  }

  $script_path = $vhost_type ? {
    'path' => "/${name}",
    'host' => "''",
  }

  # Figure out how to improve db security (manually done by
  # mysql_secure_installation)
  case $ensure {
    'present', 'absent': {
      
      exec { "${name}-install_script":
        cwd         => "${mediawiki_install_path}/maintenance",
        command     => "/usr/bin/php install.php ${name}          \
	                ${admin_name}                             \
                        --pass ${admin_password}                  \
                        --email ${admin_email}                    \
                        --server http://${server_name}            \
                        --scriptpath ${script_path}               \
                        --dbtype mysql                            \
                        --dbserver localhost                      \
                        --installdbuser root                      \
                        --installdbpass ${db_root_password}       \
                        --dbname ${db_name}                       \
                        --dbuser ${db_user}                       \
                        --dbpass ${db_password}                   \
                        --confpath ${mediawiki_conf_dir}/${name}  \
                        --lang en",
        creates     => "${mediawiki_conf_dir}/${name}/LocalSettings.php",
        subscribe   => File["${mediawiki_conf_dir}/${name}/images"],
      }

      # Ensure resource attributes common to all resources
      File {
        ensure => directory,
        owner  => 'root',
        group  => 'root',
        mode   => '0755',
      }
        
      # MediaWiki instance directory
      file { "${mediawiki_conf_dir}/${name}":
        ensure   => directory,
      }

      # Each instance needs a separate folder to upload images
      file { "${mediawiki_conf_dir}/${name}/images":
        ensure   => directory,
        group => $::operatingsystem ? {
          /(?i)(redhat|centos)/ => 'apache',
          /(?i)(debian|ubuntu)/ => 'www-data',
          default               => undef,
        }
      }
      
      # Ensure that mediawiki configuration files are included in each instance.
      mediawiki::symlinks { $name:
        conf_dir      => $mediawiki_conf_dir,
        install_files => $mediawiki_install_files,
        target_dir    => $mediawiki_install_path,
      }

      # Symlink for the mediawiki instance directory
      file { "${doc_root}/${name}":
        ensure   => link,
        target   => "${mediawiki_conf_dir}/${name}",
        require  => File["${mediawiki_conf_dir}/${name}"],
      }
     
      # Each instance has a separate vhost configuration
      apache::vhost { $name:
        port          => $port,
        docroot       => $vhost_root,
        serveradmin   => $admin_email,
        servername    => $server_name,
        vhost_name    => $ip,
        serveraliases => $server_aliases,
        ensure        => $ensure,
      }
    }
    'deleted': {
      
      # Remove the MediaWiki instance directory if it is present
      file { "${mediawiki_conf_dir}/${name}":
        ensure  => absent,
        recurse => true,
        purge   => true,
        force   => true,
      }

      # Remove the symlink for the mediawiki instance directory
      file { "${doc_root}/${name}":
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
        port          => $port,
        docroot       => $vhost_root,
        ensure        => 'absent',
      } 
    }
  }
}

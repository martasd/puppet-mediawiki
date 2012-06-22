# == Define: mediawiki
#
# This module manages a multi-tenant mediawiki installation.
#
# === Parameters:
#
# [*package_ensure*]   - state of the package
# [*db_root_password*] - password for mysql root user
# [*db_name*]          - name of the mediawiki instance mysql database
# [*db_user*]          - name of the mysql database user
# [*db_password*]      - password for the mysql database user
# [*max_memory*]       - a memcached memory limit
#
# === Examples:
#
# mediawiki { 'my_wiki1':
#   $db_root_password = 'really_long_password',
#   $db_name          = 'wiki1_user',
#   $db_password      = 'another_really_long_password',
#   $max_memory       = 1024,
#   }
#
# === Authors:
#
# Martin Dluhos <martin@gnu.org>
#
# === Copyright:
#
# Copyright 2012 Martin Dluhos
#
define mediawiki (
  $db_root_password,
  $db_password,
  $db_name           = $name,
  $db_user           = 'mediawiki_user',
  $max_memory        = 2048
  ) {

  include mediawiki::setup

  # NOTE: Need to prevent conflicts by using the same name
  class { 'apache': }

  # Manages the mysql server package and service by default
  # NOTE: Need to put a portion of this class into setup
  class { 'mysql::server':
    # I do not like the config hash below very much- ask about that
    config_hash => { 'root_password' => $db_root_password }
  }

  mysql::db { $db_name:
    user     => $db_user,
    password => $db_password,
    host     => 'localhost',
    grant    => ['all'],
  }

  # Figure out how to improve db security (manually done by
  # mysql_secure_installation)

  # Include optional packages (see mediawiki_ubuntu.txt)

  # Capture further configuration done through manually through GUI and the
  # filesystem
}

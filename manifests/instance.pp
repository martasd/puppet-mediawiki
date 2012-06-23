# == Define: mediawiki::instance
#
# This module manages a multi-tenant mediawiki installation.
#
# === Parameters
#
# [*db_name*]          - name of the mediawiki instance mysql database
# [*db_user*]          - name of the mysql database user
# [*db_password*]      - password for the mysql database user
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
  $db_user = 'mediawiki_user'
  ) {

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
  # filesystem
}

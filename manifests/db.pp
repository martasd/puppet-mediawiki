# Define: mediawiki::db
#
# Configures mysql database.
#
# Parameters:
#
# [*name*]
# [*user*]
# [*password*]
# [*host*]
# [*charset*]
#
# Actions:
#
# Requires:
#
# None
#
# Sample Usage:
#
# mediawiki::db { 'db_name':
#   $user     => 'my_user',
#   $password => 'password'
#   }
#
define mediawiki::db (
  $user, 
  $password,
  $host = $::hostname,
  $charset = 'utf8'
  ) {
 
  database { $name:
    ensure   => present,
    charset  => $charset,
    provider => 'mysql',
    require  => Package['mysql-server'],
  }

  database_user { "${user}@${host}":
    ensure        => present,
    password_hash => mysql_password($password),
    provider      => 'mysql',
    require       => Database[$name],
  }
}



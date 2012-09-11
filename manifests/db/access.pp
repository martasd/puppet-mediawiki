# Class : mediawiki::db::access
#
# This class is used to configure databases to allow
# installation of mediawiki instances. This class should
# be applied on database servers when the database server
# is split out to a seperate machine than the actual
# mediawiki instances.
#
# == Parameters
# [host] Host that sould be allowed access. You can either specify a single host
#     or a regular expression. Required.
# [password] Password to set for this database user. Required.
# [user] Name of user. Optional. Defaults to root.
# [provider] Provider to use to create user + privs. Optional. Defaults to mysql.
# === Examples
#
# class { 'mysql::server': }
#
# class { 'mediawiki::db::access':
#   host     => '10.0.1.%',
#   password => 'root_password',
# }
#
class mediawiki::db::access(
  host,
  password,
  user     = root,
  provider = 'mysql'
) {

  Class["${provider}::server"] -> Class['mediawiki::db::access']

  database_user { "${user}@${host}":
    password_hash => mysql_password($password),
    provider      => $provider,
  }
  database_grant { "${user}@${host}":
    # grants all priveleges to this user.
    privileges => 'all',
    provider   => $provider,
  }
}

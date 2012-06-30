class { 'mediawiki':
  db_root_password = 'really_really_long_password',
  package_ensure   = 'latest',
  max_memory       = '1024'
}

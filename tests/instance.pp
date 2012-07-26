mediawiki::instance { 'my_wiki1':
  db_password => 'super_long_password',
  db_name     => 'wiki1',
  db_user     => 'wiki1_user'
  port        => '80',
  status      => 'present'
}

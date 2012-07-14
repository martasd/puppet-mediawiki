# == Define: mediawiki::files
#
# This defined type makes it easier to manage mediawiki's configuration files.
# WARNING: Only for internal use!
#
# === Parameters
#
# [*instance_name*] - the name of mediawiki instance (and its config directory)
#
# === Examples
#
# mediawiki::files { $mediawiki_install_files:
#   instance_name = 'wiki1',
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
define mediawiki::files (
  $instance_name,
  ) {

  include mediawiki::params
  
  $target_dir = "${mediawiki::params::conf_dir}/${instance_name}"

  file { $name:
    ensure  => link,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    target  => "${target_dir}/${name}",
    require => File[$target_dir],
  }
}

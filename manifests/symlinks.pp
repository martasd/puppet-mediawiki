# == Define: mediawiki::symlinks
#
# This defined type manages symbolic links to mediawiki configuration files.
# WARNING: Only for internal use!
#
# === Parameters
#
# [*conf_dir*]      - directory which contains all mediawiki instannce directories
# [*install_files*] - an array of mediawiki installation files
# [*target_dir*]    - mediawiki installation directory
#
# === Example
#
# mediawiki::symlinks { $name:
#   conf_dir      => $mediawiki_conf_dir,
#   install_files => $mediawiki_install_files,
#   target_dir    => $mediawiki_install_dir,
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
define mediawiki::symlinks (
  $conf_dir,
  $install_files,
  $target_dir
  ) {
  
  # Generate an array of symlink names
  $link_files = regsubst($install_files, "^.*$", "${conf_dir}/${name}/\\0", "G")   
  mediawiki::files { $link_files:
    target_dir => $target_dir,
  }
}

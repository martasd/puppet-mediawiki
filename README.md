# Mediawiki module for Puppet

## Description

This module deploys and manages multiple mediawiki instances using one mediawiki installation. This module is designed for Enterprise Linux, Ubuntu, and Debian.

## Usage

Installs the mediawiki package:

mediawiki { 'my_wiki1':
  $db_root_password = 'really_long_password',
  $db_name          = 'wiki1_user',
  $db_password      = 'another_really_long_password',
  $max_memory       = 1024,
  }

## Reference

This module is based on puppet-mediawiki by carlasouza available at https://github.com/carlasouza/puppet-mediawiki.

# MediaWiki module for Puppet

[![Build Status](https://travis-ci.org/martasd/puppet-mediawiki.svg?branch=master)](https://travis-ci.org/martasd/puppet-mediawiki)

## Description

This module deploys and manages multiple MediaWiki instances using a single MediaWiki installation. This module has been designed and tested for CentOS 6, Red Hat Enterprise Linux 6, Debian Squeeze, Debian Wheezy, and Ubuntu Precise.

## Usage

In site.pp for the node where you wish to deploy MediaWiki, first
declare the class `mediawiki` in order to ensure that mediawiki is
installed:

    class { 'mediawiki':
      server_name        => 'www.myawesomesite.com',
      admin_email         => 'admin@myawesomesite.com',
      db_root_password => 'really_really_long_password',
      doc_root               => '/var/www',
      max_memory       => '1024'
    }

The above declaration fetches the official tarball with latest version of
MediaWiki and installs it into a directory of choice. In addition to that, it
also informs Apache of the server name to use and the email address to display
when rendering an error page, sets the password for the mysql root user,
specifies the webserver document root, and imposes a maximum memory limit for
memcached. Once you ensure that MediaWiki is installed, you can then create new
instances like this:

     mediawiki::instance { 'my_wiki1':
       db_password => 'really_long_password',
       db_name     => 'wiki1',
       db_user     => 'wiki1_user',
       port        => '80',
       ensure      => 'present'
     }
 
     mediawiki::instance { 'my_wiki2':
       db_password => 'another_really_long_password',
       db_name     => 'wiki2',
       db_user     => 'wiki2_user',
       port        => '80',
       ensure      => 'present'
     }
 
     mediawiki::instance { 'my_wiki3':
       db_password => 'yet_another_really_long_password',
       db_name     => 'wiki3',
       db_user     => 'wiki3_user',
       port        => '80',
       ensure      => 'present'
     }
 
This codeblock creates three separate instances of MediaWiki, each with its own
configuration. All wiki instances, however, share the same MediaWiki source
files, which means that the overhead of creating a new instance is very low.
Each wiki instance puts configuration files in its own directory and stores
wiki content in its own database to achieve isolation. Since a wiki instance is
implemented as a defined resource type, Puppet imposes no limit on the number
of instances you can create.

To access the first of the newly created MediaWiki instances, enter
(http://www.myawesomesite.com/my_wiki1) in your browser.

## Preconditions

Since puppet cannot automatically ensure that all parent directories of a
directory it manages exist you need to manage these yourself. Therefore, make
sure that all parent directories of `doc_root` directory, an attribute of
`mediawiki` class, exist.

Here is an example how you can do this in Puppet. Let's consider the case when
`Document Root` is configured as `/var/www/org1`. In this situation, you need
to make sure that `/var/www/org1` exists **and** both `/var/www` and
`/var/www/org1` are executable by the apache user. To achieve this goal with
Puppet on a Debian-based system, add the following to site.pp:
 
    file { '/var/www':
          ensure => 'directory',
          owner  => 'root',
          group  => 'root',
          mode   => '0755',
        }
        
    file { '/var/www/org1':
          ensure => 'directory',
          owner  => 'www-data,
          group  => 'www-data,
          mode   => '0755',
        }

On a RHEL/CentOS system, the owner and group of `/var/www/org1` needs to be set
to `apache` instead.

## Notes On Testing

Puppet module tests reside in the `spec` directory. To run tests, execute `rake
spec` anywhere in the module's directory. More information about module testing
can be found here:

[The Next Generation of Puppet Module Testing](http://puppetlabs.com/blog/the-next-generation-of-puppet-module-testing)

## Reference

This module is based on puppet-mediawiki by carlasouza available at
https://github.com/carlasouza/puppet-mediawiki. Others who contributed to this
module include James Turnbull, Zach Leslie, Nan Liu, and Branan Purvine-Riley.

require 'spec_helper'

# A few useful variables: What if someone decides to change the variable values
# in params.pp?
# mediawiki_conf_dir     
# mediawiki_install_files
# instance_root_dir      
# apache_daemon           

describe 'mediawiki::instance', :type => :define do

  context 'using default parameters on Debian' do
    let(:pre_condition) do
      'class { "mediawiki": 
         server_name      => "www.example.com",
         admin_email      => "admin@puppetlabs.com",
         db_root_password => "really_really_long_password" }'
    end
    
    let(:facts) do
      {
        :osfamily => 'Debian',
        :operatingsystem => 'Debian',
        :processorcount => 1
      }
    end
    
    let(:params) do
      {
        :db_password => 'lengthy_password'
      }
    end

    let(:title) do
      'dummy_instance'
    end
    
    it 'should have enabled the instance' do
      should contain_class('mediawiki::params')
      
      should contain_file('/etc/mediawiki/dummy_instance').with( 
        'ensure'   => 'directory',
        'owner'    => 'root',
        'group'    => 'root',
        'mode'     => '0755'
      )
      
     should contain_file('/etc/mediawiki/dummy_instance/images').with(
        'ensure'   => 'directory',
        'owner'    => 'root',
        'group'    => 'www-data',
        'mode'     => '0755'
      )
      
      should contain_mediawiki__symlinks('dummy_instance').with(
        'conf_dir'      => '/etc/mediawiki',
        'install_files' => ['api.php',
                          'api.php5',
                          'bin',
                          'docs',
                          'extensions',
                          'img_auth.php',
                          'img_auth.php5',
                          'includes',
                          'index.php',
                          'index.php5',
                          'languages',
                          'load.php',
                          'load.php5',
                          'maintenance',
                          'mw-config',
                          'opensearch_desc.php',
                          'opensearch_desc.php5',
                          'profileinfo.php',
                          'redirect.php',
                          'redirect.php5',
                          'redirect.phtml',
                          'resources',
                          'serialized',
                          'skins',
                          'StartProfiler.sample',
                          'tests',
                          'thumb_handler.php',
                          'thumb_handler.php5',
                          'thumb.php',
                          'thumb.php5',
                          'wiki.phtml'],
       'target_dir'    => '/var/www/mediawiki-1.19.1'
       )
      
      should contain_file('/var/www/wikis/dummy_instance').with(
        'ensure'   => 'link',
        'owner'    => 'root',
        'group'    => 'root'
      )

      should contain_apache__vhost('dummy_instance').with(
        'port'         => '80',
        'docroot'      => '/var/www/wikis',
        'serveradmin'  => 'admin@puppetlabs.com',
        'template'     => 'apache/vhost-default.conf.erb',
        'ensure'       => 'present'
      )
    end
  end
  
  context 'using custom parameters on Debian' do
    let(:pre_condition) do
      'class { "mediawiki": 
         server_name      => "www.example.com",
         admin_email      => "admin@puppetlabs.com",
         db_root_password => "really_really_long_password" }'
    end
    
    let(:facts) do
      {
        :osfamily => 'Debian',
        :operatingsystem => 'Debian',
        :processorcount => 1
      }
    end
    
    let(:params) do
      {
        :db_password    => 'super_long_password',
        :db_name        => 'dummy_db',
        :db_user        => 'dummy_user',
        :ip             => '192.168.100.41',
        :port           => '80',
        :server_aliases => 'wiki1instance',

      }
    end
    
    let(:title) do
      "dummy_instance"
    end
    
    it 'should have disabled the instance' do
      params.merge!({'ensure' => 'absent'})
      should contain_class('mediawiki')
      should contain_class('mediawiki::params')
      
      should contain_file('/etc/mediawiki/dummy_instance').with( 
        'ensure'   => 'directory',
        'owner'    => 'root',
        'group'    => 'root',
        'mode'     => '0755'
      )
     
      should contain_file('/etc/mediawiki/dummy_instance/images').with(
        'ensure'   => 'directory',
        'owner'    => 'root',
        'group'    => 'www-data',
        'mode'     => '0755'
      )
      
      should contain_mediawiki__symlinks('dummy_instance').with(
        'conf_dir'      => '/etc/mediawiki',
        'install_files' => ['api.php',
                          'api.php5',
                          'bin',
                          'docs',
                          'extensions',
                          'img_auth.php',
                          'img_auth.php5',
                          'includes',
                          'index.php',
                          'index.php5',
                          'languages',
                          'load.php',
                          'load.php5',
                          'maintenance',
                          'mw-config',
                          'opensearch_desc.php',
                          'opensearch_desc.php5',
                          'profileinfo.php',
                          'redirect.php',
                          'redirect.php5',
                          'redirect.phtml',
                          'resources',
                          'serialized',
                          'skins',
                          'StartProfiler.sample',
                          'tests',
                          'thumb_handler.php',
                          'thumb_handler.php5',
                          'thumb.php',
                          'thumb.php5',
                          'wiki.phtml'],
       'target_dir'    => '/var/www/mediawiki-1.19.1'
       )
       
      should contain_file('/var/www/wikis/dummy_instance').with(
        'ensure'   => 'link',
        'owner'    => 'root',
        'group'    => 'root'
      )
      
      
      should contain_apache__vhost('dummy_instance').with(
        'port'         => '80',
        'docroot'      => '/var/www/wikis',
        'serveradmin'  => 'admin@puppetlabs.com',
        'servername'    => 'www.example.com',
        'vhost_name'    => '192.168.100.41',
        'serveraliases' => 'wiki1instance',
        'template'     => 'apache/vhost-default.conf.erb',
        'ensure'       => 'absent'
      ) 
    end
    
    it 'should have deleted the instance' do
      params.merge!({'ensure' => 'deleted'})
      should contain_class('mediawiki')
      should contain_class('mediawiki::params')
      
      should contain_mysql__db('dummy_db').with(
        'user'     => 'dummy_user',
        'password' => 'super_long_password',
        'host'     => 'localhost'
      ) 
      
      should contain_file('/etc/mediawiki/dummy_instance').with( 
        'ensure'   => 'absent'
      )
     
      
      should contain_file('/var/www/wikis/dummy_instance').with(
        'ensure'   => 'absent'
      )
      
      should contain_mysql__db('dummy_db').with(
        'user'     => 'dummy_user',
        'password' => 'super_long_password',
        'host'     => 'localhost',
        'grant'    => 'all',
        'ensure'   => 'absent'
      )  
      
      should contain_apache__vhost('dummy_instance').with(
        'port'         => '80',
        'docroot'      => '/var/www/wikis',
        'ensure'       => 'absent'
      ) 
    end
  end
    

  # Add additional contexts for different Ubuntu and CentOS
  context 'using default parameters on Ubuntu' do
    let(:pre_condition) do
      'class { "mediawiki": 
         server_name      => "www.example.com",
         admin_email      => "admin@puppetlabs.com",
         db_root_password => "really_really_long_password" }'
    end
    
    let(:facts) do
      {
        :osfamily => 'Debian',
        :operatingsystem => 'Ubuntu',
        :processorcount => 1
      }
    end
    
    let(:params) do
      {
        :db_password => 'lengthy_password'
      }
    end
  end
  
  context 'using default parameters on CentOS and RedHat' do
    let(:pre_condition) do
      'class { "mediawiki": 
         server_name      => "www.example.com",
         admin_email      => "admin@puppetlabs.com",
         db_root_password => "really_really_long_password" }'
    end
    
    let(:facts) do
      {
        :operatingsystem => 'RedHat',
        :processorcount => 1
      }
    end
    
    let(:params) do
      {
        :db_password => 'lengthy_password',
      }
    end
    
    let(:title) do
      "dummy_instance"
    end
  end
end

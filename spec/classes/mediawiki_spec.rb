require 'spec_helper'
#require 'ruby-debug'

describe 'mediawiki', :type => :class do

  context 'using default parameters on Debian' do
    let(:facts) do
      {
        :osfamily => 'Debian',
        :operatingsystem => 'Debian'
      }
    end

    let(:params) do
      {
        :server_name      => 'www.example.com',
        :admin_email      => 'admin@puppetlabs.com',
        :db_root_password => 'long_password'
      }
    end

    it {
      should contain_class('mediawiki')
      should contain_class('apache')
      should contain_class('apache::mod::php')
      should contain_class('mediawiki::params')
      should contain_package('php5').with('ensure' => 'latest')
      should contain_package('php5-mysql').with('ensure'=> 'latest')
      should contain_class('mysql::server').with('config_hash' => {'root_password' => 'long_password'})
      #should contain_class('memcached').with(:max_memory => '2048')
      should contain_file('mediawiki_conf_dir').with(
        'ensure'  => 'directory',
        'path'    => '/etc/mediawiki',
        'owner'   => 'root',
        'group'   => 'root',
        'mode'    => '0755',
        'require' => '[Package[php5]{:name=>"php5"}, Package[php5-mysql]{:name=>"php5-mysql"}, Package[wget]{:name=>"wget"}]'
      )
    }
  end

  context 'using custom parameters on Debian' do
    let(:facts) do
      {
        :osfamily => 'Debian',
        :operatingsystem => 'Debian'
      }
    end

    let(:params) do
      {
        :server_name      => 'www.example.com',
        :admin_email      => 'admin@puppetlabs.com',
        :db_root_password => 'long_password',
        :doc_root         => '/var/www/wikis',
        :tarball_url      => 'http://download.wikimedia.org/mediawiki/1.19/mediawiki-1.19.1.tar.gz',
        :package_ensure   => 'installed',
        :max_memory       => '1024'
      }
    end

    it {
      should contain_class('mediawiki')
      should contain_class('apache')
      should contain_class('apache::mod::php')
      should contain_class('mediawiki::params')
      should contain_package('php5').with('ensure' => 'installed')
      should contain_package('php5-mysql').with('ensure' => 'installed')
      should contain_class('mysql::server').with('config_hash' => {'root_password' => 'long_password'})
      #should contain_class('memcached').with(:max_memory => '1024')
      should contain_file('mediawiki_conf_dir').with(
        'ensure'  => 'directory',
        'path'    => '/etc/mediawiki',
        'owner'   => 'root',
        'group'   => 'root',
        'mode'    => '0755',
      )
    }
  end

  # Implement additional contexts for different Ubuntu, CentOS, and RedHat.
  context 'using default parameters on Ubuntu' do
    let(:facts) do
      {
        :osfamily => 'Debian',
        :operatingsystem => 'Ubuntu'
      }
    end
    let(:params) do
      {
        :server_name      => 'www.example.com',
        :admin_email      => 'admin@puppetlabs.com',
        :db_root_password => 'long_password'
      }
    end
  end

  context 'using default parameters on CentOS and RedHat' do
    let(:facts) do
      {
        :osfamily => 'RedHat',
        :operatingsystem => 'RedHat'
      }
    end
    let(:params) do
      {
        :server_name      => 'www.example.com',
        :admin_email      => 'admin@puppetlabs.com',
        :db_root_password => 'long_password'
      }
    end
  end
end

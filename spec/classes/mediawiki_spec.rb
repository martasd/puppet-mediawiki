require 'spec_helper'

# Declare useful variables
packages = ['php5', 'php5-mysql', 'mediawiki', 'mediawiki-extensions']

describe 'mediawiki', :type => :class do

  context 'using default parameters on Ubuntu' do
    let(:facts) do
      {
        :operatingsystem => 'ubuntu'
      }
    end

    let(:params) do
      {
        :db_root_password => 'long_password'
      }
    end

    it {
      should include_class('apache')
      should include_class('mediawiki::params')
      should contain_package(packages).with(:ensure => 'latest')
      should contain_class('mysql::server').with(:config_hash => {:root_password => 'long_password'})
      should contain_class('memcached').with(:max_memory => '2048')
      should contain_file('mediawiki_conf_dir').with(
        :ensure  => directory,
        :path    => '/etc/mediawiki',
        :owner   => 'root',
        :group   => 'root',
        :mode    => '0755',
        :require => Package['mediawiki']
      )
    }
  end

  context 'using custom parameters on Ubuntu' do
    let(:params) do
      {
        :db_root_password => 'long_password',
        :package_ensure   => 'installed',
        :max_memory       => '1024'
      }
    end

    it {
      should include_class('apache')
      should include_class('mediawiki::params')
      should contain_package(packages).with(:ensure => 'installed')
      should contain_class('mysql::server').with(:config_hash => {:root_password => 'long_password'})
      should contain_class('memcached').with(:max_memory => '1024')
      should contain_file('mediawiki_conf_dir').with(
        :ensure  => directory,
        :path    => '/etc/mediawiki',
        :owner   => 'root',
        :group   => 'root',
        :mode    => '0755',
        :require => Package['mediawiki']
      )
    }
  end

  # Implement additional contexts for different Debian, CentOS, and RedHat
  context 'using default parameters on Debian' do
    let(:facts) do
      {
        :operatingsystem => 'debian'
      }
    end
    let(:params) do
      {
        :db_root_password => 'long_password'
      }
    end
  end

  context 'using default parameters on CentOS and RedHat' do
    let(:facts) do
      {
        :operatingsystem => 'centos'
      }
    end
    let(:params) do
      {
        :db_root_password => 'long_password'
      }
    end
  end
end

require 'spec_helper'

# A few useful variables: What if someone decides to change the variable values
# in params.pp?
# mediawiki_conf_dir     
# mediawiki_install_files
# instance_root_dir      
# apache_daemon           

describe 'mediawiki::instance', :type => :define do

  context 'using default parameters on Debian' do
    let(:facts) do
      {
        :operatingsystem => 'debian'
      }
    end
    let(:params) do
      {
        :db_password => 'lengthy_password',
      }
    end
    
    it {
      should include_class('mysql::db')
      # should contain_mysql__db(
    }
  end
  
  context 'using custom parameters on Debian' do
    let(:facts) do
      {
        :operatingsystem => 'debian'
      }
    end
    let(:params) do
      {
        :db_password => 'lengthy_password',
        :db_name     => 'knowledge_cache',
        :db_user     => 'knowledge_cacher',
        :status      => 'enabled',
      }
    end
  end
    

  # Add additional contexts for different Ubuntu and CentOS
  context 'using default parameters on Ubuntu' do
    let(:facts) do
      {
        :operatingsystem => 'ubuntu'
      }
    end
    let(:params) do
      {
        :db_password => 'lengthy_password',
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
        :db_password => 'lengthy_password',
      }
    end
  end
end

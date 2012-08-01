require 'spec_helper'

describe 'mediawiki::files', :type => :define do

  context 'using default parameters on Debian' do
    let(:facts) do
      {
        :osfamily => 'Debian',
        :operatingsystem => 'Debian'
      }
    end
    
    let(:params) do
      {
        :instance_name => 'dummy_instance'
      }
    end
    
    let(:title) do
      'api.php'
    end 
    
    it {
      should contain_class('mediawiki::params')
      should contain_mediawiki__files('api.php')
      
      should contain_file('api.php').with(
        'ensure' => 'link',
        'path'   => '/etc/mediawiki/dummy_instance/api.php',                                  
        'owner'  => 'root',
        'group'  => 'root',
        'mode'   => '0755',
        'target' => '/usr/share/mediawiki/api.php',                                  
      )
    }
  end
end

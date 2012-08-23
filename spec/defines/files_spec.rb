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
        :target_dir => '/usr/share/mediawiki'
      }
    end
    
    let(:title) do
      '/etc/mediawiki/dummy_instance/api.php'
    end 
    
    it {
      
      should contain_file('/etc/mediawiki/dummy_instance/api.php').with(
        'ensure' => 'link',
        'path'   => '/etc/mediawiki/dummy_instance/api.php',
        'owner'  => 'root',
        'group'  => 'root',
        'mode'   => '0755',
        'target' => '/usr/share/mediawiki/api.php'
      )
    }
  end
end

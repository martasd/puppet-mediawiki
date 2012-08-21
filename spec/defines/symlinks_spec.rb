require 'spec_helper'

describe 'mediawiki::symlinks', :type => :define do

  context 'using default parameters on Debian' do
    let(:facts) do
      {
        :osfamily => 'Debian',
        :operatingsystem => 'Debian'
      }
    end
    
    let(:params) do
      {
        :conf_dir      => '/etc/mediawiki',
        :install_files => ['api.php', 'config', 'extensions','img_auth.php'],
        :target_dir => '/usr/share/mediawiki'
      }
    end
    
    let(:title) do
      'dummy_instance'
    end
    
    it {
      should contain_mediawiki__files('/etc/mediawiki/dummy_instance/api.php').with(
         'target_dir' => '/usr/share/mediawiki')
      should contain_mediawiki__files('/etc/mediawiki/dummy_instance/config').with(
         'target_dir' => '/usr/share/mediawiki')
      should contain_mediawiki__files('/etc/mediawiki/dummy_instance/extensions').with(
         'target_dir' => '/usr/share/mediawiki')
      should contain_mediawiki__files('/etc/mediawiki/dummy_instance/img_auth.php').with(
         'target_dir' => '/usr/share/mediawiki')
    }
  end
end

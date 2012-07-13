require 'spec_helper'

describe 'mediawiki::params', :type => :class do

  let(:facts) do
    {
      :osfamily => 'Debian',
      :operatingsystem => 'Debian'
    }
  end

  let(:title) do
    "dummy_instance"
  end 
    
  it { should contain_mediawiki__params }

end

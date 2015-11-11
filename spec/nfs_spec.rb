require 'spec_helper'

describe 'hadoop_mapr::nfs' do
  context 'on Centos 6.6' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'centos', version: 6.6).converge(described_recipe)
    end

    it 'installs mapr-nfs package' do
      expect(chef_run).to install_package('mapr-nfs')
    end
  end
end

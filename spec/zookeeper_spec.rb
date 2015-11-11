require 'spec_helper'

describe 'hadoop_mapr::zookeeper' do
  context 'on Centos 6.6' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'centos', version: 6.6).converge(described_recipe)
    end

    it 'installs mapr-zookeeper package' do
      expect(chef_run).to install_package('mapr-zookeeper')
    end

    it "creates mapr-zookeeper service resource, but does not run it" do
      expect(chef_run).to_not disable_service('mapr-zookeeper')
      expect(chef_run).to_not enable_service('mapr-zookeeper')
      expect(chef_run).to_not reload_service('mapr-zookeeper')
      expect(chef_run).to_not restart_service('mapr-zookeeper')
      expect(chef_run).to_not start_service('mapr-zookeeper')
      expect(chef_run).to_not stop_service('mapr-zookeeper')
    end
  end
end


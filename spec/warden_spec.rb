require 'spec_helper'

describe 'hadoop_mapr::warden' do
  context 'on Centos 6.6' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'centos', version: 6.6) do |_node|
        stub_command(%r{/sys/kernel/mm/(.*)transparent_hugepage/defrag}).and_return(false)
      end.converge(described_recipe)
    end

    it 'installs mapr-core-internal package' do
      expect(chef_run).to install_package('mapr-core-internal')
    end

    it 'creates mapr-warden service resource, but does not run it' do
      expect(chef_run).to_not disable_service('mapr-warden')
      expect(chef_run).to_not enable_service('mapr-warden')
      expect(chef_run).to_not reload_service('mapr-warden')
      expect(chef_run).to_not restart_service('mapr-warden')
      expect(chef_run).to_not start_service('mapr-warden')
      expect(chef_run).to_not stop_service('mapr-warden')
    end
  end
end

require 'spec_helper'

describe 'hadoop_mapr::metrics' do
  context 'on Centos 6.6' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'centos', version: 6.6) do |_node|
        stub_command(%r{/sys/kernel/mm/(.*)transparent_hugepage/defrag}).and_return(false)
      end.converge(described_recipe)
    end

    it 'installs mapr-metrics package' do
      expect(chef_run).to install_package('mapr-metrics')
    end
  end
end

require 'spec_helper'

describe 'hadoop_mapr::hive' do
  context 'on Centos 6.6' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'centos', version: 6.6) do |node|
        node.default['hive']['hive_site']['hive.exec.local.scratchdir'] = '/tmp/hive/scratch'
        stub_command(%r{/sys/kernel/mm/(.*)transparent_hugepage/defrag}).and_return(false)
      end.converge(described_recipe)
    end

    it 'installs mapr-hive package' do
      expect(chef_run).to install_package('mapr-hive')
    end

    it 'creates hive-site.xml from template' do
      expect(chef_run).to create_template('hive-site.xml')
    end
  end
end

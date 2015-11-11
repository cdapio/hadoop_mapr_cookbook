require 'spec_helper'

describe 'hadoop_mapr::hbase' do
  context 'on Centos 6.6' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'centos', version: 6.6) do |node|
        node.default['hbase']['hbase_site']['hbase.rootdir'] = 'maprfs:///hbase'
      end.converge(described_recipe)
    end

    it 'installs mapr-hbase package' do
      expect(chef_run).to install_package('mapr-hbase')
    end

    it "creates hbase-site.xml from template" do
      expect(chef_run).to create_template('hbase-site.xml')
    end
  end
end

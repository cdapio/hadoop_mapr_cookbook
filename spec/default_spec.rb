require 'spec_helper'

describe 'hadoop_mapr::default' do
  context 'on Centos 6.6' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'centos', version: 6.6) do |node|
        node.override['hadoop_mapr']['install_dir'] = '/some/data/disk'
        stub_command(%r{/sys/kernel/mm/(.*)transparent_hugepage/defrag}).and_return(false)
      end.converge(described_recipe)
    end

    it 'creates mapr group' do
      expect(chef_run).to create_group('mapr')
    end

    it 'creates mapr user' do
      expect(chef_run).to create_user('mapr')
    end

    it 'creates install dir' do
      expect(chef_run).to create_directory('/some/data/disk')
    end

    it 'creates symlink' do
      link = chef_run.link('/opt/mapr')
      expect(link).to link_to('/some/data/disk')
    end

    it 'creates /tmp/hadoop-mapr directory' do
      expect(chef_run).to create_directory('/tmp/hadoop-mapr').with(
        mode: '1777'
      )
    end
  end

  context 'on Ubuntu 12.04' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'ubuntu', version: 12.04) do |_node|
        stub_command(%r{/sys/kernel/mm/(.*)transparent_hugepage/defrag}).and_return(false)
      end.converge(described_recipe)
    end

    it 'creates install dir' do
      expect(chef_run).to create_directory('/opt/mapr')
    end
  end
end

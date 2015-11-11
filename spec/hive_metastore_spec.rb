require 'spec_helper'

describe 'hadoop_mapr::hive_metastore' do
  context 'on Centos 6.6' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'centos', version: 6.6) do |node|
        node.default['hive']['hive_site']['hive.exec.scratchdir'] = '/hive/scratch'
        stub_command(/hadoop fs -test/).and_return(false)
      end.converge(described_recipe)
    end

    it 'installs mapr-hivemetastore package' do
      expect(chef_run).to install_package('mapr-hivemetastore')
    end

    it 'creates execute[hive-mfs-scratchdir] but does not run it' do
      expect(chef_run.execute('hive-mfs-scratchdir')).to do_nothing
    end

    it 'creates execute[hive-mfs-warehousedir] but does not run it' do
      expect(chef_run.execute('hive-mfs-warehousedir')).to do_nothing
    end
  end
end

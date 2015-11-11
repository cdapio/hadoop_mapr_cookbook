require 'spec_helper'

describe 'hadoop_mapr::hadoop_yarn' do
  context 'on Centos 6.6' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'centos', version: 6.6) do |node|
        node.default['hadoop']['core_site']['hadoop.tmp.dir'] = '/tmp'
        node.default['hadoop']['mapred_site']['mapreduce.framework.name'] = 'yarn'
        node.default['hadoop']['yarn_site']['yarn.scheduler.increment-allocation-mb'] = '1024'
      end.converge(described_recipe)
    end

    it 'installs mapr-hadoop-core package' do
      expect(chef_run).to install_package('mapr-hadoop-core')
    end

    %w(
      core-site.xml
      mapred-site.xml
      yarn-site.xml
    ).each do |file|
      it "creates #{file} from template" do
        expect(chef_run).to create_template(file)
      end
    end
  end
end

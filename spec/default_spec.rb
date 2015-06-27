require 'spec_helper'

describe 'hadoop_mapr::default' do
  context 'on Centos 6.6' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'centos', version: 6.6) do |node|
        node.automatic['domain'] = 'example.com'
      end.converge(described_recipe)
    end

    it 'creates mapr group' do
      expect(chef_run).to create_group('mapr')
    end

    it 'creates mapr user' do
      expect(chef_run).to create_user('mapr')
    end
  end

  context 'on Ubuntu 12.04' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'ubuntu', version: 12.04) do |node|
        node.automatic['domain'] = 'example.com'
      end.converge(described_recipe)
    end
  end
end

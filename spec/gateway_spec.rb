require 'spec_helper'

describe 'hadoop_mapr::gateway' do
  context 'on Centos 6.6' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'centos', version: 6.6).converge(described_recipe)
      # ChefSpec::SoloRunner.new(platform: 'centos', version: 6.6) do |node|
      #    node.automatic['domain'] = 'example.com'
      # end.converge(described_recipe)
    end

    it 'installs mapr-gateway package' do
      expect(chef_run).to install_package('mapr-gateway')
    end
  end
end


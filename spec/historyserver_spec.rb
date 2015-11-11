require 'spec_helper'

describe 'hadoop_mapr::historyserver' do
  context 'on Centos 6.6' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'centos', version: 6.6).converge(described_recipe)
    end

    it 'installs mapr-historyserver package' do
      expect(chef_run).to install_package('mapr-historyserver')
    end
  end
end


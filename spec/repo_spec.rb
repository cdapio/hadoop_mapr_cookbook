require 'spec_helper'

describe 'hadoop_mapr::repo' do
  context 'on Centos 6.6' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'centos', version: 6.6) do |node|
        node.automatic['domain'] = 'example.com'
      end.converge(described_recipe)
    end

    %w(maprtech maprecosystem).each do |repo|
      it "add #{repo} yum_repository" do
        expect(chef_run).to add_yum_repository(repo)
      end
    end
  end

  context 'on Ubuntu 12.04' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'ubuntu', version: 12.04) do |node|
        node.automatic['domain'] = 'example.com'
      end.converge(described_recipe)
    end

    %w(maprtech maprecosystem).each do |repo|
      it "add #{repo} apt_repository" do
        expect(chef_run).to add_apt_repository(repo)
      end
    end
  end
end

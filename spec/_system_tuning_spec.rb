require 'spec_helper'

describe 'hadoop_mapr::_system_tuning' do
  context 'on Centos 6.6' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'centos', version: 6.6) do |node|
        allow(::File).to receive_messages(:file? => true)
        stub_command(%r{/sys/kernel/mm/(.*)transparent_hugepage/defrag}).and_return(false)
      end.converge(described_recipe)
    end

    it 'disables overcommit' do
      expect(chef_run).to apply_sysctl_param('vm.overcommit_memory')
    end

    it 'disables swapping' do
      expect(chef_run).to apply_sysctl_param('vm.swappiness')
    end

    it 'reduce tcp retries ' do
      expect(chef_run).to apply_sysctl_param('net.ipv4.tcp_retries2')
    end

    it 'disables transparent hugepage compaction' do
      expect(chef_run).to run_execute('disable-transparent-hugepage-compaction')
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

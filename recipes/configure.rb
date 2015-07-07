#
# Cookbook Name:: hadoop_mapr
# Recipe:: configure
#
# Copyright © 2013-2015 Cask Data, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# /opt/mapr/server/configure.sh -C mapr-1724-1000.dev.continuuity.net -Z mapr-1724-1000.dev.continuuity.net
# -RM mapr-1724-1000.dev.continuuity.net -HS mapr-1724-1000.dev.continuuity.net -N mapr1724 -noDB -D /dev/sdc

# unmount data disks
#default['hadoop_mapr']['disk_list'].each do |disk|
node['hadoop_mapr']['configure_sh']['args'].each do |k,v|
  if k == '-D'
    v.split(',').each do |disk|
      next if disk.nil?

      # Chef mount resource requires the mount_point as well
      mount_cmd = Mixlib::ShellOut.new("mount")
      mount_cmd.run_command
      mount_cmd.stdout.each_line do |line|
        if line =~ /^#{disk}\son\s/
          current_mount_point = line.split(' ')[2]

          # unmount this disk
          mount current_mount_point do
            device disk
            action [:umount, :disable]
          end
        end
      end
    end
  end
end

lwrp_args = []

node['hadoop_mapr']['configure_sh']['args'].each do |k, v|
  if v.nil?
    # pass a flag
    lwrp_args.push(k)
  else
    # pass a key/value
    lwrp_args.push(k => v)
  end
end

hadoop_mapr_configure node['hadoop_mapr']['configure_sh']['cluster_name'] do
  cldb_list node['hadoop_mapr']['configure_sh']['cldb_list']
  zookeeper_list node['hadoop_mapr']['configure_sh']['zookeeper_list']
  cldb_mh_list node['hadoop_mapr']['configure_sh']['cldb_mh_list']
  refresh_roles node['hadoop_mapr']['configure_sh']['refresh_roles']
  client_only_mode node['hadoop_mapr']['configure_sh']['client_only_mode']
  args lwrp_args
  action :run
end

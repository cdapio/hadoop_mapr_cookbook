#
# Cookbook Name:: hadoop_mapr
# Recipe:: hive_metastore
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

include_recipe 'hadoop_mapr::default'

# configures hive-site.xml
include_recipe 'hadoop_mapr::hive'

package 'mapr-hivemetastore' do
  action :install
  version node['hive']['version'] if node['hive'].key?('version') && !node['hive']['version'].empty?
end

# Hive HDFS directories
warehouse_dir =
  if node['hive'].key?('hive_site') && node['hive']['hive_site'].key?('hive.metastore.warehouse.dir')
    node['hive']['hive_site']['hive.metastore.warehouse.dir']
  else
    '/user/hive/warehouse'
  end

scratch_dir =
  if node['hive'].key?('hive_site') && node['hive']['hive_site'].key?('hive.exec.scratchdir')
    node['hive']['hive_site']['hive.exec.scratchdir']
  else
    '/tmp/hive-${user.name}'
  end

node.default['hive']['hive_site']['hive.exec.scratchdir'] = scratch_dir
node.default['hive']['hive_site']['hive.metastore.warehouse.dir'] = warehouse_dir

m_user = node['hadoop_mapr']['mapr_user']['username']
m_group = node['hadoop_mapr']['mapr_user']['group']

unless scratch_dir == '/tmp/hive-${user.name}'
  execute 'hive-mfs-scratchdir' do
    command "hadoop fs -mkdir -p #{scratch_dir} && hadoop fs -chown #{m_user}:#{m_group} #{scratch_dir} && hadoop fs -chmod 777 #{scratch_dir}"
    timeout 300
    user m_user
    group m_group
    not_if "hadoop fs -test -d #{scratch_dir}", user: m_user
    action :nothing
  end
end

execute 'hive-mfs-warehousedir' do
  command "hadoop fs -mkdir -p #{warehouse_dir} && hadoop fs -chown #{m_user}:#{m_group} #{warehouse_dir} && hadoop fs -chmod 1777 #{warehouse_dir}"
  timeout 300
  user m_user
  group m_group
  not_if "hadoop fs -test -d #{warehouse_dir}", user: m_user
  action :nothing
end

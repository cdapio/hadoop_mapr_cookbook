#
# Cookbook Name:: hadoop_mapr
# Recipe:: spark_historyserver
#
# Copyright © 2013-2016 Cask Data, Inc.
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

include_recipe 'hadoop_mapr::spark'
pkg = 'mapr-spark-historyserver'

# This is the default hard-coded into MapR spark package postinstall scripts.
eventlog_dir = 'hdfs:///apps/spark'

execute 'hdfs-spark-eventlog-dir' do
  command "hdfs dfs -mkdir -p #{eventlog_dir} && hdfs dfs -chown -R spark:spark #{eventlog_dir} && hdfs dfs -chmod 1777 #{eventlog_dir}"
  user 'hdfs'
  group 'hdfs'
  timeout 300
  action :nothing
end

package pkg do
  action :install
  version node['spark']['version'] if node.key?('spark') && node['spark'].key?('version') && !node['spark']['version'].empty?
end

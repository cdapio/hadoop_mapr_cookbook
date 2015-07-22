#
# Cookbook Name:: hadoop_mapr
# Attribute:: yarn
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

###
# hbase-site.xml settings - these are the MapR defaults
###
default['hbase']['hbase_site']['hbase.cluster.distributed'] = true
default['hbase']['hbase_site']['hbase.rootdir'] = 'maprfs:///hbase'
default['hbase']['hbase_site']['hbase.zookeeper.quorum'] = node['fqdn']
default['hbase']['hbase_site']['hbase.zookeeper.property.clientPort'] = '5181'
default['hbase']['hbase_site']['dfs.support.append'] = true
default['hbase']['hbase_site']['hbase.fsutil.maprfs.impl'] = 'org.apache.hadoop.hbase.util.FSMapRUtils'
default['hbase']['hbase_site']['hbase.regionserver.handler.count'] = '30'
default['hbase']['hbase_site']['fs.mapr.threads'] = '64'

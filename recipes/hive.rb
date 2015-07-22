#
# Cookbook Name:: hadoop_mapr
# Recipe:: hive
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

pkg = 'mapr-hive'

package pkg do
  action :install
end

# hive-site.xml
my_vars = { :options => node['hive']['hive_site'] }

template "#{hive_conf_dir}/hive-site.xml" do
  source 'generic-site.xml.erb'
  mode '0644'
  owner 'root'
  group 'root'
  action :create
  variables my_vars
  only_if { node['hive'].key?('hive_site') && !node['hive']['hive_site'].empty? }
end


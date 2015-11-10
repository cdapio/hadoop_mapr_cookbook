#
# Cookbook Name:: hadoop_mapr
# Recipe:: hadoop_yarn
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

# Ensure conf directory exists
package 'mapr-hadoop-core'

# core_site yarn-site.xml, mapred-site.xml
%w(core_site mapred_site yarn_site).each do |sitefile|
  template "#{sitefile.tr('_', '-')}.xml" do
    path lazy { "#{hadoop_conf_dir}/#{sitefile.tr('_', '-')}.xml" }
    source 'generic-site.xml.erb'
    mode '0644'
    owner 'root'
    group 'root'
    action :create
    variables options: node['hadoop'][sitefile]
    only_if { node['hadoop'].key?(sitefile) && !node['hadoop'][sitefile].empty? }
  end
end

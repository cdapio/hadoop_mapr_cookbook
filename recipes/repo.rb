#
# Cookbook Name:: hadoop_mapr
# Recipe:: repo
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

mapr_release = node['hadoop_mapr']['distribution_version'].gsub(/^v/, '')
mep_release = node['hadoop_mapr']['mep_version'].to_f

# Per http://doc.mapr.com/display/MapR/JDK+Support+Matrix
if mapr_release.to_i >= 4 && node.key?('java') && node['java'].key?('jdk_version') && node['java']['jdk_version'].to_i < 7
  Chef::Application.fatal!('MapR 4.x and above require Java 7 or higher')
end

case node['platform_family']
when 'rhel'
  # Ensure that we have the proper LWRPs available
  include_recipe 'yum'

  yum_repo_url = "http://package.mapr.com/releases/v#{mapr_release}/redhat"
  yum_repo_key_url = 'http://package.mapr.com/releases/pub/maprgpg.key'

  yum_ecosystem_repo_url = if node['hadoop_mapr']['distribution_version'].to_f >= 5.2
                             "http://package.mapr.com/releases/MEP/MEP-#{mep_release}/redhat"
                           else
                             "http://package.mapr.com/releases/ecosystem-#{mapr_release.to_i}.x/redhat"
                           end

  yum_repository 'maprtech' do
    name 'maprtech'
    description 'MapR Technologies'
    url yum_repo_url
    gpgkey yum_repo_key_url
    action :add
  end

  yum_repository 'maprecosystem' do
    name 'maprecosystem'
    description 'MapR Technologies'
    url yum_ecosystem_repo_url
    gpgkey yum_repo_key_url
    gpgcheck false
    action :add
    only_if { node['hadoop_mapr']['distribution_version'] < '5.2' }
  end

  yum_repository 'mep' do
    name 'maprmep'
    description 'MapR Technologies'
    url yum_ecosystem_repo_url
    gpgkey yum_repo_key_url
    gpgcheck false
    action :add
    only_if { node['hadoop_mapr']['distribution_version'] >= '5.2' }
  end

  # TODO: include epel if mapr-metrics is enabled

when 'debian'
  # Ensure that we have the proper LWRPs available
  include_recipe 'apt'

  apt_repo_url = "http://package.mapr.com/releases/v#{mapr_release}/ubuntu"
  apt_repo_key_url = 'http://package.mapr.com/releases/pub/maprgpg.key'

  apt_ecosystem_repo_url = if node['hadoop_mapr']['distribution_version'] >= '5.2'
                             "http://package.mapr.com/releases/MEP/MEP-#{mep_release}/ubuntu"
                           else
                             "http://package.mapr.com/releases/ecosystem-#{mapr_release.to_i}.x/ubuntu"
                           end

  apt_repository 'maprtech' do
    uri apt_repo_url
    key apt_repo_key_url
    distribution 'mapr'
    components ['optional']
    action :add
  end

  apt_repository 'maprecosystem' do
    uri apt_ecosystem_repo_url
    key apt_repo_key_url
    trusted true
    distribution 'binary/'
    action :add
    only_if { node['hadoop_mapr']['distribution_version'] < '5.2' }
  end

  apt_repository 'maprmep' do
    uri apt_ecosystem_repo_url
    key apt_repo_key_url
    trusted true
    distribution 'binary/'
    action :add
    only_if { node['hadoop_mapr']['distribution_version'] >= '5.2' }
  end
end

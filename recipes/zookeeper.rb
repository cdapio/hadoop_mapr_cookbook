#
# Cookbook Name:: hadoop_mapr
# Recipe:: zookeeper
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

pkg = 'mapr-zookeeper'

package pkg do
  action :install
end

template '/opt/mapr/conf/daemon.conf' do
  source 'daemon.conf.erb'
  owner 'root'
  group 'root'
  mode 0644
  not_if { File.exist?('/opt/mapr/conf/daemon.conf' )}
end

file '/opt/mapr/zookeeper/zookeeper-3.4.5/bin/zkServer.sh' do
  owner 'mapr'
  group 'mapr'
  action :touch
end

# update the directory that will store the PID
directory "/opt/mapr/zkdata/" do
  owner 'mapr'
  group 'mapr'
end

=begin
bash "insert_line" do
  user "root"
  code <<-EOS
  echo ''
  echo 'mapr.daemon.user=mapr' >> /opt/mapr/conf/daemon.conf
  echo 'mapr.daemon.group=mapr' >> /opt/mapr/conf/daemon.conf
  echo 'mapr.daemon.runuser.warden=1' >> /opt/mapr/conf/daemon.conf
  echo 'chown mapr:mapr /opt/mapr/zookeeper/zookeeper-3.4.5/bin/zkServer.sh'
  echo 'chown mapr:mapr /opt/mapr/zkdata/'
  EOS
end
=end
service 'mapr-zookeeper' do
  status_command 'service mapr-zookeeper status'
  supports [restart: true, reload: true, status: true]
  action :nothing
end

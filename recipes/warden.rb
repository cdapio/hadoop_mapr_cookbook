#
# Cookbook Name:: hadoop_mapr
# Recipe:: warden
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

# The warden service is part of mapr-core-internal, which is a dependency of many mapr services.
# Setting fileserver as the dependency here since it should be installed on every cluster node
include_recipe 'hadoop_mapr::fileserver'

service 'mapr-warden' do
  status_command "service mapr-warden status"
  supports [:restart => true, :reload => true, :status => true]
  action :nothing
end

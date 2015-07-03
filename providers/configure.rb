#
# Cookbook Name:: hadoop_mapr
# Provider:: configure
#
# Copyright © 2013-2015 Cask Data, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

use_inline_resources if defined?(use_inline_resources)

action :run do
  # Construct argument list
  args = []

  # cldb_list
  if new_resource.cldb_list
    cldb_list = new_resource.cldb_list
    cldb_arg = cldb_list.is_a?(Array) ? cldb_list.join(',') : cldb_list
    args += ['-C', cldb_arg]
  end

  # cldb_mh_list
  if new_resource.cldb_mh_list
    cldb_mh_list = new_resource.cldb_mh_list
    if cldb_mh_list.is_a?(Array)
      # Pass -M multiple times, once for each element given
      cldb_mh_list.each do |cldb_mh|
        args += ['-M', cldb_mh]
      end
    else
      args += ['-M', cldb_mh_list]
    end
  end

  # zookeeper_list (required)
  zookeeper_list = new_resource.zookeeper_list
  zookeeper_arg = zookeeper_list.is_a?(Array) ? zookeeper_list.join(',') : zookeeper_list
  args += ['-Z', zookeeper_arg]

  # refresh_roles
  args += ['-R'] if new_resource.refresh_roles == true

  # client_only_mode
  args += ['-c'] if new_resource.client_only_mode == true

  # additional args
  additional_args = new_resource.args
  # Flatten any hashes or multi-level arrays within additional_args to arrays
  additional_args.map! do |x|
    if x.respond_to?('flatten')
      x.flatten
    else
      x
    end
  end
  # Flatten again to single-dimensional array
  args.push additional_args.flatten

  Chef::Log.info("Running configure.sh: /opt/mapr/server/configure.sh #{args.join(' ')}")

  # Run configure.sh
  execute 'running configure.sh' do
    command "/opt/mapr/server/configure.sh #{args.join(' ')}"
    action :run
  end
end

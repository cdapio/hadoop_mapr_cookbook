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
    puts "CLDB CLASS: #{cldb_list.class}"
    require 'pp'
    pp cldb_list
    cldb_arg = cldb_list.join(',') if cldb_list.kind_of?(Array)
    puts "CLDB_ARG: #{cldb_arg}"
    args = args + ['-C', cldb_arg]
  end

  # cldb_mh_list
  if new_resource.cldb_mh_list
    cldb_mh_list = new_resource.cldb_mh_list
    if cldb_mh_list.kind_of?(Array)
      # Pass -M multiple times, once for each element given
      cldb_mh_list.each do |cldb_mh|
        args = args + ['-M', cldb_mh]
      end
    else
      args = args + ['-M', cldb_mh_list]
    end
  end

  # zookeeper_list (required)
  zookeeper_list = new_resource.zookeeper_list
  zookeeper_arg = zookeeper_list.join(',') if cldb_list.kind_of?(Array)
  args = args + ['-Z', zookeeper_arg]

  # refresh_roles
  if new_resource.refresh_roles == true
    args = args + ['-R']
  end

  # client_only_mode
  if new_resource.client_only_mode == true
    args = args + ['-c']
  end



  additional_opts = new_resource.additional_opts
  # Flatten any hashes or multi-level arrays within additional_opts to arrays
  additional_opts.map! do |x|
    if x.respond_to?('flatten')
      x.flatten
    else
      x
    end
  end
  # Flatten again to single-dimensional array
  args.push additional_opts.flatten

  Chef::Log.info("Running configure.sh: /opt/mapr/server/configure.sh #{args.join(' ')}")

  execute "running configure.sh" do
    command "/opt/mapr/server/configure.sh #{args.join(' ')}"
    action :run
  end
end

__END__

# /opt/mapr/server/configure.sh -C mapr-1724-1000.dev.continuuity.net -Z mapr-1724-1000.dev.continuuity.net -RM mapr-1724-1000.dev.continuuity.net -HS mapr-1724-1000.dev.continuuity.net -N mapr1724 -noDB -D /dev/sdc


        echo "configure.sh  -C cldb_list  -Z zookeeper_list  [args]"
        echo "configure.sh  -C cldb_list -M cldb_mh_list [-M cldb_mh_list ...] -Z zookeeper_list  [args]"
        echo "configure.sh  client_only_mode  [refresh_roles] [args]"
        echo "configure.sh  refresh_roles  [client_only_mode] [args]"
        echo ""
        echo "Options:"
        echo ""
        echo "cldb_list        : hostname[:port_no] [,hostname[:port_no] ...]"
        echo "                   a list of CLDB nodes which this machine should use "
        echo "                   to connect to the MapR cluster, "
        echo "                   use this option only when CLDB servers have "
        echo "                   a single IP/hostname assigned to them "
        echo "cldb_mh_list     : nodeBeth0[:port_no][,[nodeBeth1[:port_no] ...]"
        echo "                   a list of hostnames/IP addresses "
        echo "                   which this machine should use to connect "
        echo "                   to a specific CLDB server in the MapR cluster, "
        echo "                   use this option to specify each CLDB server "
        echo "                   which is assigned more than one hostname/IP address "
        echo ""
        echo "zookeeper_list   : hostname[:port_no] [,hostname[:port_no] ...]"
        echo "client_only_mode : -c -C cldb_list [-Z zookeeper_list]"
        echo "refresh_roles    : -R [-C cldb_list] [-Z zookeeper_list]"


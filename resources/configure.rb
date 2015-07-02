#
# Cookbook Name:: hadoop_mapr
# Resource:: configure
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

actions :run
default_action :run

# /opt/mapr/server/configure.sh -C mapr-1724-1000.dev.continuuity.net -Z mapr-1724-1000.dev.continuuity.net -RM mapr-1724-1000.dev.continuuity.net -HS mapr-1724-1000.dev.continuuity.net -N mapr1724 -noDB -D /dev/sdc

# -C
attribute :cldb_list,             kind_of: [Array, String],           default: nil
# -M
attribute :cldb_mh_list,          kind_of: [Array, String],           default: nil
# -Z
attribute :zookeeper_list,        kind_of: [Array, String],           default: nil, required: true
# -D
attribute :disks,                 kind_of: [String, Array],           default: nil
# -F
attribute :disks_file,            kind_of: String,                    default: nil
# -N
attribute :cluster_name,          kind_of: String,                    default: nil, name_attribute: true
# -v
attribute :verbose,               kind_of: [TrueClass, FalseClass],   default: false
# -disk-opts
attribute :disk_opts,             kind_of: [String, Array],           default: nil
# -no-autostart
attribute :autostart,             kind_of: [TrueClass, FalseClass],   default: true
# -R
attribute :refresh_roles,         kind_of: [TrueClass, FalseClass],   default: false
# -c
attribute :client_only_mode,      kind_of: [TrueClass, FalseClass],   default: false
# --isvm
# -M7 (deprecated)
# -noDB
# -R
# -a | --create-user
# -f
# -genkeys
# -nocerts
# -S | -secure
# -maprpam
# -no-auto-permission-update
# 


# Additional options will simply be flattened and passed through as args to configure.sh
#   ex: [ '--isvm', { '-HS': 'hostA' } ]
#   results in: --isvm -HS hostA
attribute :additional_opts,       kind_of: [String, Array],           default: nil

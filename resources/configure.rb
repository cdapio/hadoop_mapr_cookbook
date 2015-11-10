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

# LWRP to configure a MapR cluster using configure.sh
# See http://doc.mapr.com/display/MapR/configure.sh for full usage/docs

actions :run
default_action :run

# -C
attribute :cldb_list,             kind_of: [Array, String, NilClass],           default: nil
# -M
attribute :cldb_mh_list,          kind_of: [Array, String, NilClass],           default: nil
# -Z
attribute :zookeeper_list,        kind_of: [Array, String, NilClass],           default: nil
# -D
attribute :cluster_name,          kind_of: String,                    name_attribute: true
# -v
attribute :refresh_roles,         kind_of: [TrueClass, FalseClass],   default: false
# -c
attribute :client_only_mode,      kind_of: [TrueClass, FalseClass],   default: false
# -no-autostart
attribute :no_autostart,          kind_of: [TrueClass, FalseClass],   default: false

# Additional args will simply be flattened and passed through as args to configure.sh
#   example input: [ '--isvm', { '-HS': 'hostA' } ]
#   results in: --isvm -HS hostA
attribute :args, kind_of: [String, Array, NilClass], default: nil

# hadoop_mapr cookbook

Note: This cookbook is under active development and not yet ready for use.

# Requirements

# Usage

# Attributes

# Recipes

# Resources

Note, the following resource(s) make use of utility scripts provided by MapR itself.  Therefore, these resources require
at a minimum the 'warden' recipe to be included in the run_list prior to invocation.

## configure

The configure resource is a wrapper around the configure.sh script provided by the mapr-core-internal package.

### Actions
Action | Description
------ | -----------
`:run` | run configure.sh

### Attributes
Attribute | Type | Default Value | Description
--------- | ---- | ------------- | -----------
`:cldb_list` | `Array` | | The list of CLDB nodes of the cluster (hostname[:port][,hostname[:port]...])
`:cldb_mh_list` | Array | | The list of multi-homed CLDB nodes of the cluster (hostname[:port][,hostname[:port] [hostname[:port],hostname[:port] ...])
`:zookeeper_list` | Array | | The list of zookeeper nodes of the cluster (hostname[:port][,hostname[:port]...])
`:cluster_name` | String | | The cluster name
`:refresh_roles` | Boolean | false | refresh roles, passes the -R flag. It is incompatable with many other options
`:client_only_mode` | Boolean | false | client only mode, passes the -c flag
`:args` | Array | | Any other options from http://doc.mapr.com/display/MapR/configure.sh. Use a key-value hash element for parameters with values

### Examples
Example usage of an initial run of configure.sh, including disk setup:
```
hadoop_mapr_configure 'my_cluster' do
  cldb_list [ 'hostA', 'hostB', 'hostC' ]
  zookeeper_list [ 'hostA', 'hostB', 'hostC' ]
  # cldb_mh_list [ 'hostDeth0,hostDeth1', 'hostEeth0,hostEeth1' ]
  refresh_roles false
  client_only_mode false
  args [ '-noDB', {'-D': '/dev/sdc'}, {'-disk-opts':'F'}, '-no-autostart' ]
  action :run
end
```

# Author

Author:: Cask Data, Inc. (<ops@cask.co>)

# Testing

# License

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this software except in compliance with the License. You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.

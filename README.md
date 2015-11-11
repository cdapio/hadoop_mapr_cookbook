# The hadoop_mapr Cookbook


# Requirements

This cookbook may work on earlier versions, but these are the minimal tested versions:

* Chef 11.16.4+
* CentOS 6.6+
* Ubuntu 12.04+

If you plan on using Hive with a database other than the embedded Derby, you will need to provide and set it up prior to starting the Hive Metastore service. Similarly, if you plan on installing `mapr-metrics`, you will need to setup MySQL prior to configuring the `mapr-metrics` service.


# Usage

This cookbook is an adaptation of the [Hadoop cookbook](https://github.com/caskdata/hadoop_cookbook) for the MapR distribution of Hadoop. It is designed to be used with a wrapper cookbook or a role with settings for configuring MapR. The services should work out of the box on a single host, but little validation is performed that you have created a working MapR installation.

This cookbook provides an [LWRP](Resources) for running the MapR [configure.sh utility](http://doc.mapr.com/display/MapR/configure.sh). Additionally, the Hadoop configuration is attribute-driven, with default attributes in place to match the [configure.sh](http://doc.mapr.com/display/MapR/configure.sh) output. The goal is to wrap and supplement the installation utilities already provided by MapR.

This cookbook is suitable for use via either `chef-client` or `chef-solo` since it does not use any `chef-server` related functionality. The cookbook defines service definitions for ZooKeeper and Warden, but it does not enable or start them by default.

This cookbook has been tested with MapR 4.1.0 and 5.0.0.


# Attributes

## MapR Distribution Attributes

* `hadoop_mapr['distribution_version']` - The version of MapR to install. Default: `5.0.0`
* `hadoop_mapr['install_dir']` - The base install dir. Default: `/opt/mapr`. If modified, `/opt/mapr` will be symlinked to this location.
* `hadoop_mapr['create_mapr_user']` - Flag to enable the MapR user creation. Default: `true`
* `hadoop_mapr['mapr_user']['username']` - The username to run MapR as. Default: `mapr`
* `hadoop_mapr['mapr_user']['group']` - The group for the MapR user. Default: `mapr`
* `hadoop_mapr['mapr_user']['uid']` - The uid for the MapR user. Default: `5000`
* `hadoop_mapr['mapr_user']['gid']` - The gid for the MapR user group. Default: `5000`
* `hadoop_mapr['mapr_user']['password']` - The password shadow hash for the MapR user. Default: hash of `mapr`

## Hadoop-specific Attributes

This cookbook generates the XML configuration files for Hadoop, overriding the MapR-provided defaults. This allows advanced configurations that would otherwise require hand-editing outside of the MapR utilities. A helper library is used to determine the install location of these configuration files.

Attribute trees are used to define each Hadoop configuration file.  The attribute name determines which file the property is place and the property name. The attribute value is the property value. For example: the attribute `hadoop_mapr['core_site']['hadoop.tmp.dir']` will configure a property named `hadoop.tmp.dir` in `core-site.xml`, located in the MapR install directory, such as `/opt/mapr/hadoop/hadoop-[version]/etc/hadoop`. All attribute values are taken as-is and only minimal configuration checking is performed on values. It is up to the user to provide a valid configuration for your cluster.

Attribute Tree | File | Location
-------------- | ---- | --------
hadoop_mapr['core_site'] | core-site.xml | `hadoop_conf_dir()`
hadoop_mapr['hbase_site'] | hbase-site.xml | `hbase_conf_dir()`
hadoop_mapr['hive_site'] | hive-site.xml | `hive_conf_dir()`
hadoop_mapr['mapred_site'] | mapred-site.xml | `hadoop_conf_dir()`
hadoop_mapr['yarn_site'] | yarn-site.xml | `hadoop_conf_dir()`

Please see the `hbase`, `hive`, and `yarn` attributes files. They contain default values which generally match the MapR-generated defaults, except where noted.


# Recipes

* `cldb.rb` - Sets up a CLDB
* `default.rb` - Sets up the install directory, MapR user, and hadoop.tmp.dir
* `fileserver.rb` - Sets up a Fileserver
* `gateway.rb` - Sets up a Gateway
* `hadoop_yarn.rb` - Sets up the Hadoop configuration
* `hadoop_yarn_nodemanager.rb` - Sets up a YARN NodeManager
* `hadoop_yarn_resourcemanager.rb` - Sets up a YARN ResourceManager
* `hbase.rb` - Sets up the HBase configuration
* `hbase_master.rb` - Sets up an HBase Master
* `hbase_regionserver.rb` - Sets up an HBase RegionServer
* `historyserver.rb` - Sets up a HistoryServer
* `hive.rb` - Sets up the Hive configuration
* `hive_metastore.rb` - Sets up a Hive Metastore
* `hive_server2.rb` - Sets up a Hive Server2
* `metrics.rb` - Installs the Metrics package
* `nfs.rb` - Installs the NFS package
* `repo.rb` - Sets up package manager repositories for the specified MapR distribution version
* `warden.rb` - Sets up a Warden service
* `webserver.rb` - Sets up a Webserver service
* `zookeeper.rb` - Sets up a ZooKeeper server


# Resources

**Note:** the following resource(s) make use of utility scripts provided by MapR itself.  Therefore, these resources require
at a minimum that the 'warden' recipe be included in the run_list prior to invocation.

## Configure
The configure resource is a wrapper around the `configure.sh` script provided by the `mapr-core-internal` package.

### Actions
Action | Description
------ | -----------
`:run` | run configure.sh

### Attributes
Attribute | Type | Default Value | Description
--------- | ---- | ------------- | -----------
`:cldb_list` | Array | | The list of CLDB nodes of the cluster (`hostname[:port][,hostname[:port]...]`)
`:cldb_mh_list` | Array | | The list of multi-homed CLDB nodes of the cluster (`hostname[:port][,hostname[:port] [hostname[:port],hostname[:port] ...]`)
`:zookeeper_list` | Array | | The list of ZooKeeper nodes of the cluster (`hostname[:port][,hostname[:port]...]`)
`:cluster_name` | String | | The name of the cluster
`:refresh_roles` | Boolean | false | Refresh roles, passes the -R flag. It is incompatable with many other options
`:client_only_mode` | Boolean | false | Client-only mode, passes the -c flag
`:args` | Array | | Any other options from http://doc.mapr.com/display/MapR/configure.sh. Use a key-value hash element for parameters with values

### Examples
Example usage of an initial run of `configure.sh`, including disk setup:
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

Author: Cask Data, Inc. (<ops@cask.co>)


# Testing


# License

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this software except in compliance with the License. You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.

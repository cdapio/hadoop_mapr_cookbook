#
# Cookbook Name:: hadoop_mapr
# Attribute:: yarn
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

###
# yarn-site.xml settings - these are the MapR defaults
###
default['hadoop']['yarn_site']['yarn.resourcemanager.hostname'] = node['fqdn']

# yarn.application.classpath - append /opt/mapr/lib/*
default['hadoop']['yarn_site']['yarn.application.classpath'] = '$HADOOP_CONF_DIR, $HADOOP_COMMON_HOME/share/hadoop/common/*, $HADOOP_COMMON_HOME/share/hadoop/common/lib/*, $HADOOP_HDFS_HOME/share/hadoop/hdfs/*, $HADOOP_HDFS_HOME/share/hadoop/hdfs/lib/*, $HADOOP_YARN_HOME/share/hadoop/yarn/*, $HADOOP_YARN_HOME/share/hadoop/yarn/lib/*, $HADOOP_COMMON_HOME/share/hadoop/mapreduce/*, $HADOOP_COMMON_HOME/share/hadoop/mapreduce/lib/*, /opt/mapr/lib/*'

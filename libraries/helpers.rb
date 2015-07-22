#
# Cookbook Name:: hadoop_mapr
# Library:: helpers
#
# Copyright © 2015 Cask Data, Inc.
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

module HadoopMapr
  # Helper methods for HadoopMapr cookbook
  module Helpers
    #
    # Get the bundled Hadoop version, from /opt/mapr/hadoopversion
    #
    def hadoop_version
      File.open('/opt/mapr/hadoop/hadoopversion', 'r').read.strip
    end

    #
    # Get the bundled Hadoop conf directory
    #
    def hadoop_conf_dir
      "/opt/mapr/hadoop/hadoop-#{hadoop_version}/etc/hadoop" unless hadoop_version.nil?
    end

    #
    # Get the bundled HBase version, from /opt/mapr/hbaseversion
    #
    def hbase_version
      File.open('/opt/mapr/hbase/hbaseversion', 'r').read.strip
    end

    #
    # Get the bundled HBase conf directory
    #
    def hbase_conf_dir
      "/opt/mapr/hbase/hbase-#{hbase_version}/conf" unless hbase_version.nil?
    end

    #
    # Get the bundled Hive conf directory
    #
    def hive_conf_dir
      result = nil
      # There is no hiveversion file, we can only guess and check
      %w(/opt/mapr/hive/hive-1.0/conf /opt/mapr/hive/hive-0.13/conf).each do |candidate|
        if File.exist?("#{candidate}/hive-site.xml")
          result = candidate
          break
        end
      end
      result
    end

    #
    # Get the bundled Hive sql dir
    #
    def hive_sql_dir
      "#{hive_conf_dir}/../scripts/metastore/upgrade" unless hive_conf_dir.nil?
    end
  end
end

# Load helpers
Chef::Recipe.send(:include, ::HadoopMapr::Helpers)
Chef::Resource.send(:include, ::HadoopMapr::Helpers)

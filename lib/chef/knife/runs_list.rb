#
# Copyright:: Copyright (c) 2013-2014 Chef Software, Inc.
# License:: Apache License, Version 2.0
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

require 'chef/reporting/knife_helpers'

class Chef
  class Knife
    class RunsList < Chef::Knife

      deps do
        # While Ruby automatically includes some data & time functions in the
        # base class, more advanced data & time functions still required the
        # modules be loaded.
        require 'time'
        require 'date'
      end

      include Chef::Reporting::KnifeHelpers

      banner "knife runs list [<node name>]"

      PROTOCOL_VERSION = '0.1.0'
      HEADERS = {'X-Ops-Reporting-Protocol-Version' => PROTOCOL_VERSION}

      option :start_time,
        :long => '--starttime MM-DD-YYYY',
        :short => '-s MM-DD-YYYY',
        :required => false,
        :description => 'Find runs with a start time great than or equal to the date provided. If the -u option is provided unix timestamps can be given instead.'

      option :end_time,
        :long => '--endtime MM-DD-YYYY',
        :short => '-e MM-DD-YYYY',
        :required => false,
        :description => 'Find runs with an end time less than or equal to the date provided. If the -u option is provided unix timestamps can be given instead.'

      option :unix_timestamps,
        :long => '--unixtimestamps',
        :short => '-u',
        :required => false,
        :boolean => true,
        :description => 'Indicates start and end times are given as unix time stamps and not date formats.'

      option :rows,
        :long => '--rows N',
        :short => '-r N',
        :required => false,
        :description => 'Specifies the rows to be returned from the database. The default is 10.'

      option :status,
        :long => '--status STATUS',
        :required => false,
        :description => 'Filters by run status (success, failure, or aborted).'

      def run
        @rest = Chef::REST.new(Chef::Config[:chef_server_url])

        node_name = name_args[0]

        check_start_and_end_times_provided()
        start_time, end_time = apply_time_args()
        check_3month_window(start_time, end_time)

        query_string = generate_query(start_time, end_time, node_name, config[:rows],
                                      config[:status])
        runs = history(query_string)

        output(runs)
      end

      private

      def generate_query(start_time, end_time, node_name = nil, rows = nil, status = nil)
        query = '/reports'
        if node_name
          query += "/nodes/#{node_name}"
        else
          query += "/org"
        end
        query += "/runs?from=#{start_time}&until=#{end_time}"
        if rows
          query += "&rows=#{rows}"
        end
        if status
          query += "&status=#{status}"
        end
        query
      end

      def history(query_string)
        runs = @rest.get_rest(query_string, false,  HEADERS)

        runs["run_history"].map do |run|
          { :run_id => run["run_id"],
            :node_name => run["node_name"],
            :status => run["status"],
            :start_time => run["start_time"] }
        end
      end

    end
  end
end

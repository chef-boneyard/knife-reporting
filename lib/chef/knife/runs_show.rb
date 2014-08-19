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
    class RunsShow < Chef::Knife

      deps do
        # While Ruby automatically includes some data & time functions in the
        # base class, more advanced data & time functions still required the
        # modules be loaded.
        require 'time'
        require 'date'
      end

      include Chef::Reporting::KnifeHelpers

      banner "knife runs show <run id>"

      PROTOCOL_VERSION = '0.1.0'
      HEADERS = {'X-Ops-Reporting-Protocol-Version' => PROTOCOL_VERSION}

      def run
        rest = Chef::REST.new(Chef::Config[:chef_server_url])

        run_id = name_args[0]

        if run_id.nil?
          show_usage
          exit 1
        elsif uuid?(run_id)
          puts "Run ID should be a Chef Client Run ID, e.g: 11111111-1111-1111-1111-111111111111"
          exit 1
        end

        query_string = "reports/org/runs/#{run_id}"

        runs = rest.get(query_string, false, HEADERS)

        if runs['run_detail']['updated_res_count'] > runs['run_resources'].length
          all_query = "#{query_string}?start=0&rows=#{runs['run_detail']['updated_res_count']}"
          runs = rest.get(all_query, false, HEADERS)
        end
        output(runs)
      end
    end
  end
end


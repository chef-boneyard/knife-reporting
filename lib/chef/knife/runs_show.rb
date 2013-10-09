class Chef
  class Knife
    class RunsShow < Chef::Knife

      deps do
        # While Ruby automatically includes some data & time functions in the
        # base class, more advanced data & time functions still required the
        # modules be loaded.
        require 'time'
        require 'date'
        require 'chef/knife/reporting_helpers'
      end

      include ReportingHelpers

      banner "knife runs show <node name> [<run id>]"

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

      def run
        rest = Chef::REST.new(Chef::Config[:chef_server_url])

        node_name = name_args[0]
        run_id = name_args[1]

        if node_name.nil?
          show_usage
          exit 1
        end

        if run_id.nil?
          # If run_id is nil then we are hitting the nodes endpoint and requesting info about multiple runs
          # start and end time options are relevant here

          check_start_and_end_times_provided()
          start_time, end_time = apply_time_args()
          check_3month_window(start_time, end_time)
          query_string = "reports/nodes/#{node_name}/runs?from=#{start_time}&until=#{end_time}"
        else
          # If run_id is not nil, then we want a specific run and start and end times are irrelevent
          query_string = "reports/nodes/#{node_name}/runs/#{run_id}"
        end

        runs = rest.get(query_string, false, HEADERS)

        output(runs)
      end

    end
  end
end


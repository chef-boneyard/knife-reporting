class Chef
  class Knife
    class RunsList < Chef::Knife

      deps do
        # While Ruby automatically includes some data & time functions in the
        # base class, more advanced data & time functions still required the
        # modules be loaded.
        require 'time'
        require 'date'
        require 'chef/knife/reporting_helpers'
      end

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

      def run
        @rest = Chef::REST.new(Chef::Config[:chef_server_url])

        node_name = name_args[0]

        check_start_and_end_times_provided()
        start_time, end_time = apply_time_args()
        check_3month_window(start_time, end_time)

        if node_name
          runs = node_history(node_name, start_time, end_time)
        else
          runs = org_history(start_time, end_time)
        end


        output(runs)
      end

      private

      def org_history(start_time, end_time)
        runs = @rest.get_rest("reports/org/runs", false,  HEADERS)

        runs["run_history"].map do |run|
          { :run_id => run["run_id"],
            :node_name => run["node_name"],
            :status => run["status"],
            :start_time => run["start_time"] }
        end
      end

      def node_history(node_name, start_time, end_time)
        runs = @rest.get_rest( "reports/nodes/#{node_name}/runs", false, HEADERS )

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



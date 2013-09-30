class Chef
  class Knife
    class RunsShow < Chef::Knife
      banner "knife runs show <node name> [<run id>]"

      PROTOCOL_VERSION = '0.1.0'
      HEADERS = {'X-Ops-Reporting-Protocol-Version' => PROTOCOL_VERSION}
      SECONDS_IN_24HOURS = 86400

      # Requiring these as unix timestamps is not the best user friendly format
      # but it is what the server expects.
      # Options to supply the time in other formats should be provided
      # and knife should convert it.
      # Do we have libs to do this already for other plugins?

      option :start_time,
        :long => '--start_time UNIX_TIMESTAMP',
        :short => '-s UNIX_TIMESTAMP',
        :required => false,
        :description => 'Find runs with a start time great than or equal to the time provided'

      option :end_time,
        :long => '--end_time UNIX_TIMESTAMP',
        :short => '-e UNIX_TIMESTSAMP',
        :required => false,
        :description => 'Find runs with an end time less than or equal to the time provided'

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

          verify_time_args()
          start_time, end_time = apply_time_args()
          query_string = "reports/nodes/#{node_name}/runs?from=#{start_time}&until=#{end_time}"
        else
          # If run_id is not nil, then we want a specific run and start and end times are irrelevent
          query_string = "reports/nodes/#{node_name}/runs/#{run_id}"
        end

        runs = rest.get(query_string, false, HEADERS)

        output(runs)
      end

      def verify_time_args()
        if config[:start_time] && !config[:end_time]
          ui.error("The start_time option was provided, but the end_time option was not. If one is provided, the other is required.")
          exit 1
        elsif config[:end_time] && !config[:start_time]
          ui.error("The end_time option was provided, but the start_time option was not. If one is provided, the other is required.")
          exit 1
        end
      end

      def apply_time_args()
        if config[:start_time] && config[:end_time]
          start_time = config[:start_time]
          end_time = config[:end_time]
        else
          start_time, end_time = last_24hours_time_window()
        end

        return start_time, end_time
      end


      def last_24hours_time_window()
        # Time is calculated as a unix timestamp
        end_time = Time.now.to_i
        start_time = end_time - SECONDS_IN_24HOURS
        return start_time, end_time
      end

    end
  end
end


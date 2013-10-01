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

      banner "knife runs show <node name> [<run id>]"

      PROTOCOL_VERSION = '0.1.0'
      HEADERS = {'X-Ops-Reporting-Protocol-Version' => PROTOCOL_VERSION}
      SECONDS_IN_24HOURS = 86400
      # Approximate, b/c of course the length of a month can vary
      SECONDS_IN_3MONTHS = 7889230

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


      # Helper Functions

      def apply_time_args()
        if config[:start_time] && config[:end_time]
          start_time, end_time = convert_to_unix_timestamps()
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

      def check_start_and_end_times_provided()
        if config[:start_time] && !config[:end_time]
          ui.error("The start_time option was provided, but the end_time option was not. If one is provided, the other is required.")
          exit 1
        elsif config[:end_time] && !config[:start_time]
          ui.error("The end_time option was provided, but the start_time option was not. If one is provided, the other is required.")
          exit 1
        end
      end

      def convert_to_unix_timestamps()
        if config[:unix_timestamps]
          start_time = config[:start_time].to_i
          end_time = config[:end_time].to_i
        else
          # Take user supplied input, assumes it is in a valid date format,
          # convert to a date object to ensure we have the proper date format for
          # passing to the time object (but converting is not a validation step,
          # so bad user input will still be bad)
          # then convert to a time object, and then convert to a unix timestamp
          # An error could potentially be thrown if the conversions don't work
          # Question: will this work on windows?
          start_time = Time.parse(Date.strptime(config[:start_time], '%m-%d-%Y').to_s).to_i
          end_time = Time.parse(Date.strptime(config[:end_time], '%m-%d-%Y').to_s).to_i
        end

        return start_time, end_time
      end

      def check_3month_window(start_time, end_time)
        # start_time and end_time are unix timestamps
        if (end_time - start_time) > SECONDS_IN_3MONTHS
          ui.error("Requesting information for more than three months at a time is disallowed. Please try a smaller timeframe.")
          exit 1
        end
      end

    end
  end
end


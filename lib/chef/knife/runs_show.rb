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

      banner "knife runs show <run id>"

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

        run_id = name_args[0]

        if run_id.nil?
          show_usage
          exit 1
        elsif is_not_uuid(run_id)
          puts "Run ID should be a Chef Client Run ID, e.g: 11111111-1111-1111-1111-111111111111"
          exit 1
        end

        query_string = "reports/org/runs/#{run_id}"

        runs = rest.get(query_string, false, HEADERS)

        output(runs)
      end

    end
  end
end


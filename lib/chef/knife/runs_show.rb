class Chef
  class Knife
    class RunsShow < Chef::Knife
      banner "knife runs show <node name> [<run id>]"

      PROTOCOL_VERSION = '0.1.0'
      HEADERS = {'X-Ops-Reporting-Protocol-Version' => PROTOCOL_VERSION}
      SECONDS_IN_24HOURS = 86400


      def run
        rest = Chef::REST.new(Chef::Config[:chef_server_url])

        node_name = name_args[0]
        run_id = name_args[1]

        if node_name.nil?
          show_usage
          exit 1
        end

        start_time, end_time = last_24hours_time_window()
        query_string = "reports/nodes/#{node_name}/runs/#{run_id}?from=#{start_time}&until=#{end_time}"
        runs = rest.get(query_string, false, HEADERS)

        output(runs)
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


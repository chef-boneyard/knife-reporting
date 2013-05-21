class Chef
  class Knife
    class RunsShow < Chef::Knife
      banner "knife runs show <node name> [<run id>]"

      PROTOCOL_VERSION = '0.1.0'
      HEADERS = {'X-Ops-Reporting-Protocol-Version' => PROTOCOL_VERSION}

      def run
        rest = Chef::REST.new(Chef::Config[:chef_server_url])

        node_name = name_args[0]
        run_id = name_args[1]

        runs = rest.get_rest( "reports/nodes/#{node_name}/runs/#{run_id}", false, HEADERS )

        output(runs)
      end
    end
  end
end


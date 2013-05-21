class Chef
  class Knife
    class RunsList < Chef::Knife
      banner "knife runs list [<node name>]"

      PROTOCOL_VERSION = '0.1.0'
      HEADERS = {'X-Ops-Reporting-Protocol-Version' => PROTOCOL_VERSION}

      def run
        @rest = Chef::REST.new(Chef::Config[:chef_server_url])

        node_name = name_args[0]

        if node_name
          runs = node_history(node_name)
        else
          runs = org_history
        end


        output(runs)
      end

      private

      def org_history
        runs = @rest.get_rest("reports/org/runs", false,  HEADERS)

        runs["run_history"].map do |run|
          { :run_id => run["run_id"],
            :node_name => run["node_name"],
            :status => run["status"],
            :start_time => run["start_time"] }
        end
      end

      def node_history(node_name)
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



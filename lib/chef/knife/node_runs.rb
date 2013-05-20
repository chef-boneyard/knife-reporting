class Chef
  class Knife
    class NodeRuns < Chef::Knife
      banner "knife node runs <node name>"

      option :detail,
        :long => '--detail RUN_ID',
        :description => "Get detailed information about a specific node run"

      PROTOCOL_VERSION = '0.1.0'

      def run
        rest = Chef::REST.new(Chef::Config[:chef_server_url])

        node_name = name_args[0]

        if config[:detail]
          url = "reports/nodes/#{node_name}/runs/#{config[:detail]}"
        else
          url = "reports/nodes/#{node_name}/runs"
        end

        runs = rest.get_rest(url, false, {'X-Ops-Reporting-Protocol-Version' => PROTOCOL_VERSION} )

        if config[:detail]
          run_history = runs
        else
          run_history = runs["run_history"].map do |run|
            # For some reason we don't return a run_id so we have to strip it from the uri
            { :run_id => run["uri"].split("/").last,
              :node_name => run["node_name"],
              :status => run["status"],
              :start_time => run["start_time"] }
          end
        end

        output(run_history)
      end
    end
  end
end


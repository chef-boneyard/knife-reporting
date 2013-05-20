class Chef
  class Knife
    class RunHistory < Chef::Knife
      banner "knife run history"

      PROTOCOL_VERSION = '0.1.0'

      def run
        rest = Chef::REST.new(Chef::Config[:chef_server_url])

        runs = rest.get_rest("reports/org/runs", false, {'X-Ops-Reporting-Protocol-Version' => PROTOCOL_VERSION} )

        run_history = runs["run_history"].map do |run|
          { :run_id => run["run_id"],
            :node_name => run["node_name"],
            :status => run["status"],
            :start_time => run["start_time"] }
        end

        output(run_history)
      end
    end
  end
end



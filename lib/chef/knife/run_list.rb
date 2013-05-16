class Chef
  class Knife
    class RunHistory < Chef::Knife
      banner "knife run history"

      PROTOCOL_VERSION = '0.1.0'

      def run
        rest = Chef::REST.new(Chef::Config[:chef_server_url])

        runs = rest.get_rest("reports/org/runs", false, {'X-Ops-Reporting-Protocol-Version' => PROTOCOL_VERSION} )
        output(runs)
      end
    end
  end
end



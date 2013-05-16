# This will not be included in the final release. It's just to create a node run
# for testing.

class Chef
  class Knife
    class RunCreate < Chef::Knife
      require 'uuidtools'

      banner "knife run create"

      PROTOCOL_VERSION = '0.1.0'

      def run
        rest = Chef::REST.new(Chef::Config[:chef_server_url])

        @end_time = (Time.now + 20).to_s

        run = rest.post_rest("reports/nodes/bobnode/runs", new_node_run, {'X-Ops-Reporting-Protocol-Version' => PROTOCOL_VERSION} )
        id = run["run_id"]
        rest.post_rest("reports/nodes/bobnode/runs/#{id}", valid_run_content(2), {'X-Ops-Reporting-Protocol-Version' => PROTOCOL_VERSION} )
        output("Creating Run")
      end


      def valid_run_content(num_resources)
        content = JSON.parse(valid_run_content_value(num_resources))
        content["resources"][1]["delta"] = <<-EOS
0,0
-this line removed
+this line added
EOS
        content
      end

      def valid_run_content_value(num_resources)
        template = <<-EOS
{
   "action" : "end",
   "resources" : [
%s
    ],
   "total_res_count" : "%d",
   "run_list" : "xyz",
   "status" : "success",
   "data" :  {
     "exception" : {
       "class" : "Some::Class",
       "message" : "Message Goes Here",
       "backtrace" : "From A to B",
       "description" : {},
       "donotcare" : "this value doesn't matter"
     }
   },
   "end_time" : "#{@end_time}",
   "start_time" : "#{@start_time_str}"
}
EOS
        template % [run_resources_value(num_resources), num_resources]
      end


      def run_resources_value(count)
        template = <<-EOS
    {
      "type" : "file",
      "id" : "%d",
      "name" : "dummy",
      "duration" : "1200",
      "result" : "modified",
      "cookbook_name" : "Fried Smurf Secrets",
      "cookbook_version" : "18",
      "before" : {
           "irrelevant" : "true"
      },
      "after" : {
           "irrelevant" : "true"
      },
      "delta" : "blahblah"
    }
EOS

        (1..count).map {|n| template  % n}.compact().join(",")
      end

      def new_node_run
        { "action" => "start",
          "run_id" => uuid,
          "start_time" => start_time }
      end

      def uuid
        # Ensure uuid is a string to prevent trying to json encode the object
        UUIDTools::UUID.random_create.to_s
      end


      def start_time
        @start_time_str = Time.now.to_s
      end

    end
  end
end


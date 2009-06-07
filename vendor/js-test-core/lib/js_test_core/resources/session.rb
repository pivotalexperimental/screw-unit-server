module JsTestCore
  module Resources
    class Session < Resources::Resource
      map "/sessions"

      get "/:session_id" do
        runner = Runner.find(session_id)
        if runner
          body = if runner.running?
            "status=#{RUNNING}"
          else
            if runner.successful?
              "status=#{SUCCESSFUL_COMPLETION}"
            else
              "status=#{FAILURE_COMPLETION}&reason=#{runner.session_run_result}"
            end
          end
          [
            200,
            {'Content-Length' => body.length},
            body
          ]
        else
          not_found
        end
      end

      RUNNING = 'running'
      SUCCESSFUL_COMPLETION = 'success'
      FAILURE_COMPLETION = 'failure'

      def associated_with_a_runner?
        id.to_s != ""
      end

      protected

      def session_id
        params["session_id"]
      end

      def not_found
        body = Representations::NotFound.new(:message => "Could not find session #{session_id}").to_s
        [
          404,
          {
            "Content-Type" => "text/html",
            "Content-Length" => body.size.to_s
          },
          body
        ]
      end
    end
  end
end
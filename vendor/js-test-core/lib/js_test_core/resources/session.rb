module JsTestCore
  module Resources
    class Session < Resources::Resource
      class Collection < Resources::Resource
        route ANY do |env, id|
          Session.new(env.merge(:id => id))
        end
      end

      RUNNING = 'running'
      SUCCESSFUL_COMPLETION = 'success'
      FAILURE_COMPLETION = 'failure'

      property :id

      def get
        runner = Runner.find(id)
        if runner
          connection.send_head
          if runner.running?
            connection.send_body("status=#{RUNNING}")
          else
            if runner.successful?
              connection.send_body("status=#{SUCCESSFUL_COMPLETION}")
            else
              connection.send_body("status=#{FAILURE_COMPLETION}&reason=#{runner.session_run_result}")
            end
          end
        else
          connection.send_head(404)
          connection.send_body("")
        end
      end

      route 'finish' do |env, name|
        SessionFinish.new(env.merge(:session => self))
      end

      def associated_with_a_runner?
        id.to_s != ""
      end
    end
  end
end
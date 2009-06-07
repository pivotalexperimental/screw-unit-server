module JsTestCore
  module Resources
    class SessionFinish < Resources::Resource
      map("/sessions/:session_id/finish")

      post "/" do
        runner = Runner.find(session_id)
        if runner
          Runner.finalize(session.id, request['text'])
        else
          STDOUT.puts request['text']
        end
        [200, {}, request['text']]
      end

      protected
      def session_id
        params["session_id"]
      end
    end
  end
end
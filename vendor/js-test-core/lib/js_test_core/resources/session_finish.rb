module JsTestCore
  module Resources
    class SessionFinish < ThinRest::Resource
      property :session
      
      def post
        if session.associated_with_a_runner?
          Runner.finalize(session.id, rack_request['text'])
        else
          STDOUT.puts rack_request['text']
        end
        connection.send_head
        connection.send_body("")
      end
    end
  end
end
module JsTestCore
  module Resources
    class SessionFinish < ThinRest::Resource
      property :session
      
      def post
        if session.id == 'user'
          STDOUT.puts rack_request['text']
        else
          Runner.finalize(session.id, rack_request['text'])
        end
        connection.send_head
        connection.send_body("")
      end
    end
  end
end
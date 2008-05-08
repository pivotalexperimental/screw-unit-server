module Thin
  class JsTestCoreConnection < Connection
    def process
      # Add client info to the request env
      @request.remote_address = remote_address

      env = @request.env
      env['js_test_core.connection'] = self
      @response.status, @response.headers, @response.body = @app.call(env)
      send_data @response.head
      if !@response.body.empty? || @response.headers.to_s.include?("Content-Length: 0")
        send_body @response.body
      end
    rescue Exception => e
      handle_error e
    end

    def send_body(rack_response)
      rack_response.each do |chunk|
        send_data chunk
      end
      # If no more request on that same connection, we close it.
      close_connection_after_writing unless persistent?
    rescue Exception => e
      handle_error e
    ensure
      @request.close  rescue nil
      @response.close rescue nil

      # Prepare the connection for another request if the client
      # supports HTTP pipelining (persistent connection).
      post_init if persistent?
    end

    def handle_error(error)
      log "!! Unexpected error while processing request: #{error.message}"
      log error.backtrace
      log_error
      close_connection rescue nil
    end
  end
end
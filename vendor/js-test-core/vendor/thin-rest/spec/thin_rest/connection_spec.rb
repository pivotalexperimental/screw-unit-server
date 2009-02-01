require File.expand_path("#{File.dirname(__FILE__)}/../thin_rest_spec_helper")

module ThinRest
  describe Connection do
    describe "#process" do
      attr_reader :result
      before do
        stub(connection).socket_address {'0.0.0.0'}

        @result = ""
        stub(EventMachine).send_data do |signature, data, data_length|
          result << data
        end
      end

      context "when the call is successful" do
        context "when the request has Connection: close" do
          it "sends the response to the socket with a Connection: close response header" do
            mock(connection).close_connection_after_writing
            connection.receive_data "GET /subresource HTTP/1.1\r\nConnection: close\r\nHost: _\r\n\r\n"
            result.should include("GET response")
            result.should include("Connection: close")
          end

          it "closes the connection" do
            mock(connection).close_connection_after_writing
            connection.receive_data "GET /subresource HTTP/1.1\r\nConnection: close\r\nHost: _\r\n\r\n"
          end
        end

        context "when the request does not have Connection: close" do
          it "sends the response to the socket without a Connection: close response header" do
            connection.receive_data "GET /subresource HTTP/1.1\r\nHost: _\r\n\r\n"
            result.should include("GET response")
            result.should_not include("Connection: close")
          end

          it "does not close the connection" do
            dont_allow(connection).close_connection_after_writing
            connection.receive_data "GET /subresource HTTP/1.1\r\nHost: _\r\n\r\n"
          end

          context "when a second request is made" do
            it "sends the response for the second request and not for the first request" do
              connection.receive_data "GET /subresource HTTP/1.1\r\nHost: _\r\n\r\n"
              result.should include("GET response")
              result.should_not include("Another GET response")

              connection.receive_data "GET /another_subresource HTTP/1.1\r\nHost: _\r\n\r\n"
              result.should include("Another GET response")
            end
          end
        end
      end

      context "when the call raises an error" do
        it "responds with a 500 page and logs the error" do
          error = nil
          mock(connection).log_error(is_a(Exception)) do |error_arg|
            error = error_arg
          end
          mock(connection).send_head(500)
          mock(connection).send_body(Regexp.new(ErrorSubresource::ERROR_MESSAGE))

          connection.receive_data "GET /error_subresource HTTP/1.1\r\nHost: _\r\n\r\n"
          error.message.should =~ Regexp.new("/error_subresource")
        end
      end
    end
    
    describe "#send_head" do
      before do
        @connection = create_connection
        stub(EventMachine).close_connection
      end

      context "when passed no arguments" do
        it "responds with a 200 HTTP header excluding the Content-Length" do
          expected_header = "HTTP/1.1 200 OK\r\nServer: Thin Rest Server\r\n"
          mock(EventMachine).send_data( connection.signature, expected_header, expected_header.length ) {expected_header.length}
          connection.send_head
        end
      end

      context "when passed 301" do
        it "responds with a 301 HTTP header excluding the Content-Length" do
          expected_header = "HTTP/1.1 301 OK\r\nServer: Thin Rest Server\r\n"
          mock(EventMachine).send_data( connection.signature, expected_header, expected_header.length ) {expected_header.length}
          connection.send_head(301)
        end
      end

      context "when passed additional parameters" do
        it "responds with the additional parameters in the header" do
          expected_header = "HTTP/1.1 301 OK\r\nServer: Thin Rest Server\r\nLocation: http://google.com\r\n"
          mock(EventMachine).send_data( connection.signature, expected_header, expected_header.length ) {expected_header.length}
          connection.send_head(301, :Location => "http://google.com")
        end

        context "when not passed Content-length" do
          it 'does not end with \r\n\r\n' do
            expected_header = "HTTP/1.1 301 OK\r\nServer: Thin Rest Server\r\nLocation: http://google.com\r\n"
            mock(EventMachine).send_data( connection.signature, expected_header, expected_header.length ) {expected_header.length}
            connection.send_head(301, :Location => "http://google.com")
          end
        end

        context "when passed Content-Length" do
          it 'when passed a Symbol representation of Content-Length ends with \r\n\r\n' do
            expected_header = "HTTP/1.1 301 OK\r\nServer: Thin Rest Server\r\nContent-Length: 10\r\n\r\n"
            mock(EventMachine).send_data( connection.signature, expected_header, expected_header.length ) {expected_header.length}
            connection.send_head(301, :'Content-Length' => 10)
          end

          it 'when passed a String representation of Content-Length ends with \r\n\r\n' do
            expected_header = "HTTP/1.1 301 OK\r\nServer: Thin Rest Server\r\nContent-Length: 10\r\n\r\n"
            mock(EventMachine).send_data( connection.signature, expected_header, expected_header.length ) {expected_header.length}
            connection.send_head(301, 'Content-Length' => 10)
          end
        end
      end
    end

    describe "#send_body" do
      before do
        @connection = create_connection
        stub(EventMachine).close_connection
      end

      it "responds with Content-Length and the body" do
        data = "The data"
        header = "Content-Length: #{data.length}\r\n\r\n"

        mock(EventMachine).send_data( connection.signature, header, header.length ) {header.length}
        mock(EventMachine).send_data( connection.signature, data, data.length ) {data.length}

        connection.send_body data
      end
    end

    describe "#unbind" do
      attr_reader :game_session

      before do
        stub_send_data
        stub(EventMachine).close_connection
        @connection = create_connection
        params = "param_1=1&param_2=2"
        body = "#{params}\r\n"
        connection.receive_data("POST /subresource HTTP/1.1\r\nHost: _\r\n\r\n#{body}")
      end

      it "calls connection_finished on the backend to protect against memory leaks" do
        mock(connection.backend).connection_finished(connection)
        connection.unbind
      end

      it "does not send data or add a timer of any type" do
        dont_allow(EventMachine).send_data
        dont_allow(EventMachine).add_timer

        connection.unbind
      end
    end

    describe "#handle_error" do
      before do
        @connection = create_connection
        Thin::Logging.silent = true
      end

      it "logs the error" do
        error = RuntimeError.new("Unexpected Error")
        stub(error).backtrace(caller)

        stub(connection).warn
        mock.proxy(connection).log_error(error)
        mock.proxy(connection).log_error(anything)

        connection.handle_error(error)
      end
    end

    describe "#persistent?" do
      before do
        @connection = create_connection
        stub(connection).socket_address {'0.0.0.0'}
      end

      context "when #request.persistent? is true" do
        it "returns true" do
          stub(connection.request).persistent? {true}
          connection.should be_persistent
        end
      end

      context "when #request.persistent? is false" do
        it "returns false" do
          stub(connection.request).persistent? {false}
          connection.should_not be_persistent
        end
      end
    end
  end
end

require File.expand_path("#{File.dirname(__FILE__)}/../unit_spec_helper")

module Thin
  describe JsTestCoreConnection do
    describe "#process" do
      attr_reader :connection, :result
      before do
        @connection = JsTestCoreConnection.new('signature')
        stub(connection).socket_address {'0.0.0.0'}

        @result = ""
        stub(EventMachine).send_data do |signature, data, data_length|
          result << data
        end
      end

      describe "and the call is successful" do
        describe "and the body is not empty" do
          before do
            mock(app = Object.new).call(is_a(Hash)) do
              [200, {}, 'The Body']
            end
            connection.app = app
          end

          it "sends the response to the socket and closes the connection" do
            mock(connection).close_connection_after_writing
            connection.receive_data "GET /specs HTTP/1.1\r\nHost: _\r\n\r\n"
            result.should include("The Body")
          end
        end

        describe "and the body is empty" do
          describe "and the Content-Length header is 0" do
            before do
              mock(app = Object.new).call(is_a(Hash)) do
                [200, {"Content-Length" => '0'}, []]
              end
              connection.app = app
            end

            it "sends the response to the socket and closes the connection" do
              mock(connection).close_connection_after_writing
              connection.receive_data "GET /specs HTTP/1.1\r\nHost: _\r\n\r\n"
            end
          end

          describe "and the Content-Length header is > 0" do
            before do
              mock(app = Object.new).call(is_a(Hash)) do
                [200, {"Content-Length" => '55'}, []]
              end
              connection.app = app
            end

            it "keeps the connection open" do
              dont_allow(connection).close_connection_after_writing
              connection.receive_data "GET /specs HTTP/1.1\r\nHost: _\r\n\r\n"
            end
          end

          describe "and the Content-Length header is not passed in" do
            before do
              mock(app = Object.new).call(is_a(Hash)) do
                [200, {}, []]
              end
              connection.app = app
            end

            it "keeps the connection open" do
              dont_allow(connection).close_connection_after_writing
              connection.receive_data "GET /specs HTTP/1.1\r\nHost: _\r\n\r\n"
            end
          end
        end
      end

      describe "and the call raises an error" do
        it "logs the error and closes the connection" do
          mock(app = Object.new).call(is_a(Hash)) do
            raise "An Error"
          end
          connection.app = app
          mock(connection).log(anything).at_least(1)
          mock(connection).close_connection

          connection.receive_data "GET /specs HTTP/1.1\r\nHost: _\r\n\r\n"
        end
      end
    end
  end
end
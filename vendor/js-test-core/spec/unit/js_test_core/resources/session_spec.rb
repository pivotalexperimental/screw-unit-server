require File.expand_path("#{File.dirname(__FILE__)}/../../unit_spec_helper")

module JsTestCore
  module Resources
    describe Session do
      describe "GET /sessions/:session_id" do
        attr_reader :driver, :session_id

        context "when there is no Runner with the :session_id" do
          it "responds with a 404" do
            session_id = "invalid_session_id"
            Runner.find(session_id).should be_nil

            mock(connection).send_head(404)
            mock(connection).send_body("")

            connection.receive_data("GET /sessions/#{session_id} HTTP/1.1\r\nHost: _\r\n\r\n")
          end
        end

        context "when there is a Runner with the :session_id" do
          attr_reader :session_runner
          before do
            @driver = FakeSeleniumDriver.new
            @session_id = FakeSeleniumDriver::SESSION_ID
            stub(Selenium::SeleniumDriver).new('localhost', 4444, '*firefox', 'http://0.0.0.0:8080') do
              driver
            end

            connection_that_starts_firefox = create_connection
            stub(connection_that_starts_firefox).send_head
            stub(connection_that_starts_firefox).send_body
            connection_that_starts_firefox.receive_data("POST /runners/firefox HTTP/1.1\r\nHost: _\r\nContent-Length: 0\r\n\r\n")
            @session_runner = Runner.find(session_id)
            session_runner.should be_running
          end

          context "when a Runner with the :session_id is running" do
            it "responds with a 200 and status=running" do
              mock(connection).send_head
              mock(connection).send_body("status=#{Resources::Session::RUNNING}")

              connection.receive_data("GET /sessions/#{session_id} HTTP/1.1\r\nHost: _\r\n\r\n")
            end
          end

          context "when a Runner with the :session_id has completed" do
            context "when the session has a status of 'success'" do
              before do
                session_runner.finalize("")
                session_runner.should be_successful
              end

              it "responds with a 200 and status=success" do
                mock(connection).send_head
                mock(connection).send_body("status=#{Resources::Session::SUCCESSFUL_COMPLETION}")

                connection.receive_data("GET /sessions/#{session_id} HTTP/1.1\r\nHost: _\r\n\r\n")
              end
            end

            context "when the session has a status of 'failure'" do
              attr_reader :reason
              before do
                @reason = "Failure stuff"
                session_runner.finalize(reason)
                session_runner.should be_failed
              end

              it "responds with a 200 and status=failure and reason" do
                mock(connection).send_head
                mock(connection).send_body("status=#{Resources::Session::FAILURE_COMPLETION}&reason=#{reason}")

                connection.receive_data("GET /sessions/#{session_id} HTTP/1.1\r\nHost: _\r\n\r\n")
              end
            end
          end
        end
      end
    end
  end
end

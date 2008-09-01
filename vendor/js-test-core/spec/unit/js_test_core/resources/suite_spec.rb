require File.expand_path("#{File.dirname(__FILE__)}/../../unit_spec_helper")

module JsTestCore
  module Resources
    describe Suite do
      describe "GET /suites/:suite_id" do
        attr_reader :driver, :suite_id

        context "when there is no Runner with the :suite_id" do
          it "responds with a 404" do
            suite_id = "invalid_suite_id"
            Runners::Runner.find(suite_id).should be_nil

            mock(connection).send_head(404)
            mock(connection).send_body("")

            connection.receive_data("GET /suites/#{suite_id} HTTP/1.1\r\nHost: _\r\n\r\n")
          end
        end

        context "when there is a Runner with the :suite_id" do
          attr_reader :suite_runner
          before do
            @driver = "Selenium Driver"
            @suite_id = "DEADBEEF"
            stub(Selenium::SeleniumDriver).new('localhost', 4444, '*firefox', 'http://0.0.0.0:8080') do
              driver
            end

            stub(driver).start
            stub(driver).session_id {suite_id}
            connection_that_starts_firefox = create_connection
            stub(connection_that_starts_firefox).send_head
            stub(connection_that_starts_firefox).send_body
            connection_that_starts_firefox.receive_data("POST /runners/firefox HTTP/1.1\r\nHost: _\r\nContent-Length: 0\r\n\r\n")
            @suite_runner = Runners::Runner.find(suite_id)
            suite_runner.should be_running
          end

          context "when a Runner with the :suite_id is running" do
            it "responds with a 200 and status=running" do
              mock(connection).send_head
              mock(connection).send_body("status=#{Resources::Suite::RUNNING}")

              connection.receive_data("GET /suites/#{suite_id} HTTP/1.1\r\nHost: _\r\n\r\n")
            end
          end

          context "when a Runner with the :suite_id has completed" do
            context "when the suite has a status of 'success'" do
              before do
                stub(driver).stop
                suite_runner.finalize("")
                suite_runner.should be_successful
              end

              it "responds with a 200 and status=success" do
                mock(connection).send_head
                mock(connection).send_body("status=#{Resources::Suite::SUCCESSFUL_COMPLETION}")

                connection.receive_data("GET /suites/#{suite_id} HTTP/1.1\r\nHost: _\r\n\r\n")
              end
            end

            context "when the suite has a status of 'failure'" do
              attr_reader :reason
              before do
                stub(driver).stop
                @reason = "Failure stuff"
                suite_runner.finalize(reason)
                suite_runner.should be_failed
              end

              it "responds with a 200 and status=failure and reason" do
                mock(connection).send_head
                mock(connection).send_body("status=#{Resources::Suite::FAILURE_COMPLETION}&reason=#{reason}")

                connection.receive_data("GET /suites/#{suite_id} HTTP/1.1\r\nHost: _\r\n\r\n")
              end
            end
          end
        end
      end
    end
  end
end

require File.expand_path("#{File.dirname(__FILE__)}/../../unit_spec_helper")

module JsTestCore
  module Resources
    describe Suite do
      describe "GET /suites/:suite_id" do
        attr_reader :driver, :suite_id, :suite_runner

        context "when there is no Runner with the :suite_id" do
          it "responds with a 404" do
            suite_id = "66666666"
            Runners::FirefoxRunner.find(suite_id).should be_nil

            mock(connection).send_head(404)
            mock(connection).send_body("")

            connection.receive_data("GET /suites/#{suite_id} HTTP/1.1\r\nHost: _\r\n\r\n")
          end
        end

        context "when a Runner with the :suite_id is running" do
          before do
            @driver = "Selenium Driver"
            @suite_id = 12345
            stub(Selenium::SeleniumDriver).new('localhost', 4444, '*firefox', 'http://0.0.0.0:8080') do
              driver
            end

            @suite_runner = Runners::FirefoxRunner.new
            stub(suite_runner).driver {driver}
            stub(driver).session_id {suite_id}
            Runners::FirefoxRunner.register(suite_runner)
            suite_runner.should be_running
          end

          it "responds with a 200 and status=running" do
            mock(connection).send_head
            mock(connection).send_body("status=#{Resources::Suite::RUNNING}")

            connection.receive_data("GET /suites/#{suite_id} HTTP/1.1\r\nHost: _\r\n\r\n")
          end
        end

        context "when a Runner with the :suite_id has completed" do
          before do
            @driver = "Selenium Driver"
            @suite_id = 12345
            stub(Selenium::SeleniumDriver).new('localhost', 4444, '*firefox', 'http://0.0.0.0:8080') do
              driver
            end

            @suite_runner = Runners::FirefoxRunner.new
            stub(suite_runner).driver {driver}
            stub(driver).session_id {suite_id}
            stub(driver).stop
            Runners::FirefoxRunner.register(suite_runner)
            suite_runner.should be_running
          end
          
          context "when the suite has a status of 'success'" do
            before do
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

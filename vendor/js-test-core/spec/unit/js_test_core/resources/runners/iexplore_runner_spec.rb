require File.expand_path("#{File.dirname(__FILE__)}/../../../unit_spec_helper")

module JsTestCore
  module Resources
    describe Runners::IExploreRunner do
      attr_reader :request, :driver, :suite_id

      before do
        @driver = "Selenium Driver"
        @suite_id = "DEADBEEF"
        stub(Selenium::SeleniumDriver).new('localhost', 4444, '*iexplore', 'http://0.0.0.0:8080') do
          driver
        end
      end

      describe "POST /runners/iexplore" do
        before do
          stub(Thread).start.yields
          stub(connection).send_head
          stub(connection).send_body
        end

        it "responds with a 200 and the suite_id" do
          stub(driver).start
          stub(driver).open
          stub(driver).session_id {suite_id}

          mock(connection).send_head
          mock(connection).send_body("suite_id=#{suite_id}")
          connection.receive_data("POST /runners/iexplore HTTP/1.1\r\nHost: _\r\n\r\n")
        end

        describe "when a selenium_host parameter is passed into the request" do
          before do
            stub(driver).start
            stub(driver).open
            stub(driver).session_id {suite_id}
          end

          it "starts the Selenium Driver with the passed in selenium_host" do
            mock(Selenium::SeleniumDriver).new('another-machine', 4444, '*iexplore', 'http://0.0.0.0:8080') do
              driver
            end
            body = "selenium_host=another-machine"
            connection.receive_data("POST /runners/iexplore HTTP/1.1\r\nHost: _\r\nContent-Length: #{body.length}\r\n\r\n#{body}")
          end
        end

        describe "when a selenium_host parameter is not passed into the request" do
          before do
            stub(driver).start
            stub(driver).open
            stub(driver).session_id {suite_id}
          end

          it "starts the Selenium Driver from localhost" do
            mock(Selenium::SeleniumDriver).new('localhost', 4444, '*iexplore', 'http://0.0.0.0:8080') do
              driver
            end
            body = "selenium_host="
            connection.receive_data("POST /runners/iexplore HTTP/1.1\r\nHost: _\r\nContent-Length: #{body.length}\r\n\r\n#{body}")
          end
        end

        describe "when a selenium_port parameter is passed into the request" do
          before do
            stub(driver).start
            stub(driver).open
            stub(driver).session_id {suite_id}
          end

          it "starts the Selenium Driver with the passed in selenium_port" do
            mock(Selenium::SeleniumDriver).new('localhost', 4000, '*iexplore', 'http://0.0.0.0:8080') do
              driver
            end
            body = "selenium_port=4000"
            connection.receive_data("POST /runners/iexplore HTTP/1.1\r\nHost: _\r\nContent-Length: #{body.length}\r\n\r\n#{body}")
          end
        end

        describe "when a selenium_port parameter is not passed into the request" do
          before do
            stub(driver).start
            stub(driver).open
            stub(driver).session_id {suite_id}
          end

          it "starts the Selenium Driver from localhost" do
            mock(Selenium::SeleniumDriver).new('localhost', 4444, '*iexplore', 'http://0.0.0.0:8080') do
              driver
            end
            body = "selenium_port="
            connection.receive_data("POST /runners/iexplore HTTP/1.1\r\nHost: _\r\nContent-Length: #{body.length}\r\n\r\n#{body}")
          end
        end

        describe "when a spec_url is passed into the request" do
          it "runs Selenium with the passed in host and part to run the specified spec suite in iexplore" do
            mock(Selenium::SeleniumDriver).new('localhost', 4444, '*iexplore', 'http://another-host:8080') do
              driver
            end
            mock(driver).start
            mock(driver).open("http://another-host:8080/specs/subdir")
            mock(driver).session_id {suite_id}.at_least(1)

            body = "spec_url=http://another-host:8080/specs/subdir"
            connection.receive_data("POST /runners/iexplore HTTP/1.1\r\nHost: _\r\nContent-Length: #{body.length}\r\n\r\n#{body}")
          end
        end

        describe "when a spec_url is not passed into the request" do
          before do
            mock(Selenium::SeleniumDriver).new('localhost', 4444, '*iexplore', 'http://0.0.0.0:8080') do
              driver
            end
          end

          it "uses Selenium to run the entire spec suite in iexplore" do
            mock(driver).start
            mock(driver).open("http://0.0.0.0:8080/specs")
            mock(driver).session_id {suite_id}.at_least(1)

            body = "spec_url="
            connection.receive_data("POST /runners/iexplore HTTP/1.1\r\nHost: _\r\nContent-Length: #{body.length}\r\n\r\n#{body}")
          end
        end
      end

      describe "#finalize" do
        attr_reader :runner
        before do
          stub(driver).start
          stub(driver).open
          stub(driver).session_id {suite_id}

          create_runner_connection = create_connection
          stub(create_runner_connection).send_head
          stub(create_runner_connection).send_body
          create_runner_connection.receive_data("POST /runners/iexplore HTTP/1.1\r\nHost: _\r\n\r\n")
          @runner = Resources::Runners::Runner.find(suite_id)
          mock(driver).stop
        end

        it "kills the browser and stores the #suite_run_result" do
          suite_run_result = "The suite run result"
          runner.finalize(suite_run_result)
          runner.suite_run_result.should == suite_run_result
        end

        it "causes #running? to be false" do
          runner.finalize("")
        end

        context "when passed an empty string" do
          it "causes #successful? to be true" do
            runner.finalize("")
            runner.should be_successful
            runner.should_not be_failed
          end
        end

        context "when passed a non-empty string" do
          it "causes #successful? to be false" do
            runner.finalize("A bunch of error stuff")
            runner.should_not be_successful
            runner.should be_failed
          end
        end
      end

    end
  end
end

require File.expand_path("#{File.dirname(__FILE__)}/../../../unit_spec_helper")

module JsTestCore
  module Resources
    describe Runner do
      attr_reader :request, :driver, :session_id, :selenium_browser_start_command, :body

      def self.before_with_selenium_browser_start_command(selenium_browser_start_command="selenium browser start command")
        before do
          @driver = FakeSeleniumDriver.new
          @session_id = FakeSeleniumDriver::SESSION_ID
          @selenium_browser_start_command = selenium_browser_start_command
          @body = "selenium_browser_start_command=#{selenium_browser_start_command}"
          stub(Selenium::Client::Driver).new('localhost', 4444, selenium_browser_start_command, 'http://0.0.0.0:8080') do
            driver
          end
        end
      end

      after do
        Runner.send(:instances).clear
      end

      describe ".find" do
        attr_reader :runner
        before_with_selenium_browser_start_command
        before do
          @runner = Runner.new(:connection => connection, :selenium_browser_start_command => selenium_browser_start_command)
          stub(runner).driver {driver}
          stub(driver).session_id {session_id}
          Runner.register(runner)
        end
        
        context "when passed an id for which there is a corresponding Runner" do
          it "returns the Runner" do
            Runner.find(session_id).should == runner
          end
        end

        context "when passed an id for which there is no corresponding Runner" do
          it "returns nil" do
            invalid_id = "666666666666666"
            Runner.find(invalid_id).should be_nil
          end
        end
      end

      describe ".finalize" do
        attr_reader :runner
        before_with_selenium_browser_start_command
        describe "when there is a runner for the passed in session_id" do
          before do
            @runner = Runner.new(:connection => connection, :selenium_browser_start_command => selenium_browser_start_command)
            stub(runner).driver {driver}
            stub(driver).session_id {"DEADBEEF"}

            Runner.register(runner)
            runner.session_id.should == session_id
          end

          it "finalizes the Runner that has the session_id and keeps the Runner in memory" do
            mock.proxy(driver).stop
            mock.proxy(runner).finalize("Browser output")
            Runner.find(session_id).should == runner
            Runner.finalize(session_id, "Browser output")
            Runner.find(session_id).should == runner
          end
        end

        describe "when there is not a runner for the passed in session_id" do
          it "does nothing" do
            lambda do
              Runner.finalize("6666666", "nothing happens")
            end.should_not raise_error
          end
        end
      end

      describe "POST /runners" do
        before_with_selenium_browser_start_command
        before do
          stub(Thread).start.yields
          stub(connection).send_head
          stub(connection).send_body
        end

        it "responds with a 200 and the session_id" do
          mock(connection).send_head
          mock(connection).send_body("session_id=#{session_id}")
          connection.receive_data("POST /runners HTTP/1.1\r\nHost: _\r\nContent-Length: #{body.length}\r\n\r\n#{body}")
        end

        it "starts the Selenium Driver, creates a SessionID cookie, and opens the spec page" do
          mock(driver).start
          stub(driver).session_id {session_id}
          mock(driver).create_cookie("session_id=#{session_id}")
          mock(driver).open("/")
          mock(driver).open("/specs")

          mock(Selenium::Client::Driver).new('localhost', 4444, selenium_browser_start_command, 'http://0.0.0.0:8080') do
            driver
          end
          connection.receive_data("POST /runners HTTP/1.1\r\nHost: _\r\nContent-Length: #{body.length}\r\n\r\n#{body}")
        end

        describe "when a selenium_host parameter is passed into the request" do
          before do
            body << "&selenium_host=another-machine"
          end

          it "starts the Selenium Driver with the passed in selenium_host" do
            mock(Selenium::Client::Driver).new('another-machine', 4444, selenium_browser_start_command, 'http://0.0.0.0:8080') do
              driver
            end
            connection.receive_data("POST /runners HTTP/1.1\r\nHost: _\r\nContent-Length: #{body.length}\r\n\r\n#{body}")
          end
        end

        describe "when a selenium_host parameter is not passed into the request" do
          before do
            body << "&selenium_host="
          end

          it "starts the Selenium Driver from localhost" do
            mock(Selenium::Client::Driver).new('localhost', 4444, selenium_browser_start_command, 'http://0.0.0.0:8080') do
              driver
            end
            connection.receive_data("POST /runners HTTP/1.1\r\nHost: _\r\nContent-Length: #{body.length}\r\n\r\n#{body}")
          end
        end

        describe "when a selenium_port parameter is passed into the request" do
          before do
            body << "&selenium_port=4000"
          end

          it "starts the Selenium Driver with the passed in selenium_port" do
            mock(Selenium::Client::Driver).new('localhost', 4000, selenium_browser_start_command, 'http://0.0.0.0:8080') do
              driver
            end
            connection.receive_data("POST /runners HTTP/1.1\r\nHost: _\r\nContent-Length: #{body.length}\r\n\r\n#{body}")
          end
        end

        describe "when a selenium_port parameter is not passed into the request" do
          before do
            body << "&selenium_port="
          end

          it "starts the Selenium Driver from localhost" do
            mock(Selenium::Client::Driver).new('localhost', 4444, selenium_browser_start_command, 'http://0.0.0.0:8080') do
              driver
            end
            connection.receive_data("POST /runners HTTP/1.1\r\nHost: _\r\nContent-Length: #{body.length}\r\n\r\n#{body}")
          end
        end

        describe "when a spec_url is passed into the request" do
          it "runs Selenium with the passed in host and part to run the specified spec session in Firefox" do
            mock(Selenium::Client::Driver).new('localhost', 4444, selenium_browser_start_command, 'http://another-host:8080') do
              driver
            end
            mock(driver).start
            stub(driver).create_cookie
            mock(driver).open("/")
            mock(driver).open("/specs/subdir")
            mock(driver).session_id {session_id}.at_least(1)

            body << "&spec_url=http://another-host:8080/specs/subdir"
            connection.receive_data("POST /runners HTTP/1.1\r\nHost: _\r\nContent-Length: #{body.length}\r\n\r\n#{body}")
          end
        end

        describe "when a spec_url is not passed into the request" do
          before do
            mock(Selenium::Client::Driver).new('localhost', 4444, selenium_browser_start_command, 'http://0.0.0.0:8080') do
              driver
            end
          end

          it "uses Selenium to run the entire spec session in Firefox" do
            mock(driver).start
            stub(driver).create_cookie
            mock(driver).open("/")
            mock(driver).open("/specs")
            mock(driver).session_id {session_id}.at_least(1)

            body << "&spec_url="
            connection.receive_data("POST /runners HTTP/1.1\r\nHost: _\r\nContent-Length: #{body.length}\r\n\r\n#{body}")
          end
        end
      end

      describe "POST /runners/firefox" do
        before_with_selenium_browser_start_command "*firefox"

        it "creates a Runner whose #driver started with '*firefox'" do
          stub(Thread).start.yields
          stub(connection).send_head
          stub(connection).send_body

          mock(connection).send_head
          mock(connection).send_body("session_id=#{session_id}")

          Runner.find(session_id).should be_nil
          connection.receive_data("POST /runners/firefox HTTP/1.1\r\nHost: _\r\n\r\n")
          runner = Runner.find(session_id)
          runner.class.should == Runner
          runner.driver.should == driver
        end
      end

      describe "POST /runners/iexplore" do
        before_with_selenium_browser_start_command "*iexplore"

        it "creates a Runner whose #driver started with '*iexplore'" do
          stub(Thread).start.yields
          stub(connection).send_head
          stub(connection).send_body

          mock(connection).send_head
          mock(connection).send_body("session_id=#{session_id}")

          Runner.find(session_id).should be_nil
          connection.receive_data("POST /runners/iexplore HTTP/1.1\r\nHost: _\r\n\r\n")
          runner = Runner.find(session_id)
          runner.class.should == Runner
          runner.driver.should == driver
        end
      end

      describe "#running?" do
        before_with_selenium_browser_start_command
        context "when the driver#session_started? is true" do
          it "returns true" do
            create_runner_connection = create_connection
            stub(create_runner_connection).send_head
            stub(create_runner_connection).send_body
            create_runner_connection.receive_data("POST /runners HTTP/1.1\r\nHost: _\r\nContent-Length: #{body.length}\r\n\r\n#{body}")

            runner = Resources::Runner.find(session_id)
            runner.driver.session_started?.should be_true
            runner.should be_running
          end
        end

        context "when the driver#session_started? is false" do
          it "returns false" do
            create_runner_connection = create_connection
            stub(create_runner_connection).send_head
            stub(create_runner_connection).send_body
            create_runner_connection.receive_data("POST /runners HTTP/1.1\r\nHost: _\r\nContent-Length: #{body.length}\r\n\r\n#{body}")

            runner = Resources::Runner.find(session_id)
            runner.driver.stop
            runner.driver.session_started?.should be_false
            runner.should_not be_running
          end
        end
      end

      describe "#finalize" do
        attr_reader :runner
        before_with_selenium_browser_start_command
        before do
          create_runner_connection = create_connection
          stub(create_runner_connection).send_head
          stub(create_runner_connection).send_body
          create_runner_connection.receive_data("POST /runners HTTP/1.1\r\nHost: _\r\nContent-Length: #{body.length}\r\n\r\n#{body}")
          @runner = Resources::Runner.find(session_id)
          mock.proxy(driver).stop
        end

        it "kills the browser and stores the #session_run_result" do
          session_run_result = "The session run result"
          runner.finalize(session_run_result)
          runner.session_run_result.should == session_run_result
        end

        it "sets #session_run_result" do
          runner.finalize("the result")
          runner.session_run_result.should == "the result"
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

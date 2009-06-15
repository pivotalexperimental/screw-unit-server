require File.expand_path("#{File.dirname(__FILE__)}/../../unit_spec_helper")

module JsTestCore
  module Models
    describe SeleniumSession do
      attr_reader :driver, :selenium_session, :browser_host, :spec_url, :selenium_browser_start_command, :selenium_host, :selenium_port

      before do
        @driver = FakeSeleniumDriver.new

        @browser_host = "http://localhost:8080"
        @spec_url = "#{browser_host}/specs"
        @selenium_browser_start_command = "*firefox"
        @selenium_host = "localhost"
        @selenium_port = 4444

        stub.proxy(Selenium::Client::Driver).new do
          driver
        end

        @selenium_session = SeleniumSession.new(
          :spec_url => spec_url,
          :selenium_browser_start_command => selenium_browser_start_command,
          :selenium_host => selenium_host,
          :selenium_port => selenium_port
        )
      end

      def self.started
        attr_reader :session_id
        before do
          selenium_session.start
          @session_id = selenium_session.session_id
        end
      end

      describe "#initialize" do
        it "creates a Selenium Driver" do
          Selenium::Client::Driver.should have_received.new(selenium_host, selenium_port, selenium_browser_start_command, browser_host)
        end
      end

      describe ".find" do
        started
        context "when passed an id for which there is a corresponding selenium_session" do
          it "returns the selenium_session" do
            SeleniumSession.find(session_id).should == selenium_session
          end
        end

        context "when passed an id for which there is no corresponding selenium_session" do
          it "returns nil" do
            invalid_id = "666666666666666"
            SeleniumSession.find(invalid_id).should be_nil
          end
        end
      end

      describe "#start" do
        it "starts the Selenium Driver, opens the home page, sets the session_id cookie, and opens the spec page" do
          stub(Thread).start.yields
          mock.proxy(driver).start.ordered
          mock.proxy(driver).open("/").ordered
          mock.proxy(driver).create_cookie("session_id=#{FakeSeleniumDriver::SESSION_ID}").ordered
          mock.proxy(driver).open("/specs").ordered

          selenium_session.start
        end
      end

      describe "#running?" do
        started
        context "when the driver#session_started? is true" do
          it "returns true" do
            driver.session_started?.should be_true
            selenium_session.should be_running
          end
        end

        context "when the driver#session_started? is false" do
          it "returns false" do
            driver.stop
            driver.session_started?.should be_false
            selenium_session.should_not be_running
          end
        end
      end

      describe "#finish" do
        started
        
        before do
          mock.proxy(driver).stop
        end

        it "kills the browser and stores the #run_result" do
          run_result = "The session run result"
          selenium_session.finish(run_result)
          selenium_session.run_result.should == run_result
        end

        it "sets #run_result" do
          selenium_session.finish("the result")
          selenium_session.run_result.should == "the result"
        end

        context "when passed an empty string" do
          it "causes #successful? to be true" do
            selenium_session.finish("")
            selenium_session.should be_successful
            selenium_session.should_not be_failed
          end
        end

        context "when passed a non-empty string" do
          it "causes #successful? to be false" do
            selenium_session.finish("A bunch of error stuff")
            selenium_session.should_not be_successful
            selenium_session.should be_failed
          end
        end
      end
    end
  end
end
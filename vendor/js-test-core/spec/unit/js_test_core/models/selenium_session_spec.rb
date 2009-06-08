require File.expand_path("#{File.dirname(__FILE__)}/../../unit_spec_helper")

module JsTestCore
  module Models
    describe SeleniumSession do
      attr_reader :driver, :session_id, :selenium_session

      before do
        @driver = FakeSeleniumDriver.new
        @selenium_session = SeleniumSession.new(:spec_url => "http://localhost:8080/specs")
        stub(selenium_session).driver {driver}
        driver.start
        @session_id = driver.session_id
        SeleniumSession.register(selenium_session)
      end

      describe ".find" do
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

      describe "#running?" do
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

      describe "#finalize" do
        attr_reader :selenium_session
        
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
require File.expand_path("#{File.dirname(__FILE__)}/../../../unit_spec_helper")

module JsTestCore
  module Resources
    describe Runners::Runner do
      attr_reader :request, :driver, :suite_id

      before do
        @driver = "Selenium Driver"
        @suite_id = "DEADBEEF"
        stub(Selenium::SeleniumDriver).new('localhost', 4444, '*firefox', 'http://0.0.0.0:8080') do
          driver
        end
      end

      describe ".find" do
        attr_reader :runner
        before do
          @runner = Runners::FirefoxRunner.new
          stub(runner).driver {driver}
          stub(driver).session_id {suite_id}
          Runners::Runner.register(runner)
        end
        
        context "when passed an id for which there is a corresponding Runner" do
          it "returns the Runner" do
            Runners::Runner.find(suite_id).should == runner
          end
        end

        context "when passed an id for which there is no corresponding Runner" do
          it "returns nil" do
            invalid_id = "666666666666666"
            Runners::Runner.find(invalid_id).should be_nil
          end
        end
      end

      describe ".finalize" do
        attr_reader :runner
        describe "when there is a runner for the passed in suite_id" do
          before do
            @request = Rack::Request.new( Rack::MockRequest.env_for('/runners/firefox') )
            @response = Rack::Response.new
            @runner = Runners::Runner.new(:connection => connection)
            stub(runner).driver {driver}
            stub(driver).session_id {"DEADBEEF"}

            Runners::Runner.register(runner)
            runner.suite_id.should == suite_id
          end

          it "finalizes the Runner that has the suite_id and keeps the Runner in memory" do
            mock(driver).stop
            mock.proxy(runner).finalize("Browser output")
            Runners::Runner.find(suite_id).should == runner
            Runners::Runner.finalize(suite_id, "Browser output")
            Runners::Runner.find(suite_id).should == runner
          end
        end

        describe "when there is not a runner for the passed in suite_id" do
          it "does nothing" do
            lambda do
              Runners::Runner.finalize("6666666", "nothing happens")
            end.should_not raise_error
          end
        end
      end
    end
  end
end

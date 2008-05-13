require File.expand_path("#{File.dirname(__FILE__)}/../../unit_spec_helper")

module JsTestCore
  module Resources
    describe Runners do
      attr_reader :runner
      before do
        @runner = Runners.new
      end

      describe "#locate" do
        it "when passed 'firefox', returns a Firefox1Runner" do
          runner.locate('firefox').is_a?(Runners::FirefoxRunner).should be_true
        end

        it "when not passed 'firefox', raises an error" do
          lambda do
            runner.locate('invalid')
          end.should raise_error
        end
      end
    end
  end
end
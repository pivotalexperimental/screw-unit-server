require File.expand_path("#{File.dirname(__FILE__)}/../../unit_spec_helper")

module JsTestCore
  module Resources
    describe Suite do
    attr_reader :stdout
    before do
      @stdout = StringIO.new
      Suite.const_set(:STDOUT, stdout)
    end

    after do
      Suite.__send__(:remove_const, :STDOUT)
    end

    describe ".locate" do
      it "when passed an identifier, returns an instance of Suite with the identifier" do
        instance = Suite.locate('foobar')
        instance.class.should == Suite
        instance.id.should == 'foobar'
      end
    end

    describe "#locate" do
      attr_reader :suite
      before do
        @suite = Suite.new('foobar')
      end

      it "when passed 'finish', returns a SuiteFinish that has access to the suite" do
        suite_finish = suite.locate('finish')
        suite_finish.class.should == SuiteFinish
        suite_finish.suite.should == suite
      end

      it "when not passed 'finish', raises ArgumentError" do
        lambda do
          suite.locate('invalid')
        end.should raise_error(ArgumentError, "Invalid path: invalid")
      end
    end
  end
  end
end

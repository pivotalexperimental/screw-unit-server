require File.expand_path("#{File.dirname(__FILE__)}/../../unit_spec_helper")

module JsTestCore
  module Resources
    describe SuiteFinish do
    attr_reader :stdout, :suite_finish, :suite
    before do
      @stdout = StringIO.new
      SuiteFinish.const_set(:STDOUT, stdout)
      @suite = Suite.new('foobar')
      @suite_finish = SuiteFinish.new(suite)
    end

    after do
      SuiteFinish.__send__(:remove_const, :STDOUT)
    end

    describe ".post" do
      describe "when the request has no guid" do
        it "writes the body of the request to stdout" do
          body = "The text in the POST body"
          request = Rack::Request.new({'rack.input' => StringIO.new("text=#{body}")})
          request.body.string.should == "text=#{body}"
          response = Rack::Response.new

          suite_finish.post(request, response)
          stdout.string.should == "#{body}\n"
        end

        it "returns an empty string" do
          body = "The text in the POST body"
          request = Rack::Request.new({'rack.input' => StringIO.new("text=#{body}")})
          request.body.string.should == "text=#{body}"
          response = Rack::Response.new

          suite_finish.post(request, response).should == ""
        end
      end
    end
  end
  end
end

require File.expand_path("#{File.dirname(__FILE__)}/../../unit_spec_helper")

module JsTestCore
  module Resources
    describe FileNotFound do
      attr_reader :request, :response, :file_not_found

      before do
        WebRoot.dispatch_specs
        stub(EventMachine).send_data
        stub(EventMachine).close_connection
        @request = create_request('get', '/invalid')
        @response = Rack::Response.new
        @file_not_found = FileNotFound.new('invalid')
      end

      describe "#get" do
        it "returns a 404 response code with an error message" do
          file_not_found.get(request, response)
          response.status.should == 404
          response.body.should include("Path invalid not found. You may want to try the /specs directory.")
        end
      end
    end
  end
end
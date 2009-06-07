require File.expand_path("#{File.dirname(__FILE__)}/../../unit_spec_helper")

module JsTestCore
  module Resources
    describe Dir do
      attr_reader :dir, :absolute_path, :relative_path

      describe "GET /stylesheets - Top level directory" do
        it "returns a page with a of files in the directory" do
          response = get("/stylesheets")
          response.should be_http(
            200,
            {},
            %r(<a href="example.css">example.css</a>)
          )
        end
      end

      describe "GET /javascripts/subdir - Subdirectory" do
        it "returns a page with a of files in the directory" do
          response = get("/javascripts/subdir")
          response.should be_http(
            200,
            {},
            %r(<a href="bar.js">bar.js</a>)
          )
        end
      end

      describe "GET /javascripts/i_dont_exist - ResourceNotFound" do
        it "returns a 404 error" do
          response = get("/javascripts/i_dont_exist")
          response.should be_http(
            404,
            {},
            Regexp.new("File /javascripts/i_dont_exist not found")
          )
        end
      end
    end
  end
end

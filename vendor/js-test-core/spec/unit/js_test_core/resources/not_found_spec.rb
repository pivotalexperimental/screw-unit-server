require File.expand_path("#{File.dirname(__FILE__)}/../../unit_spec_helper")

module JsTestCore
  module Resources
    describe WebRoot do
      describe "GET / - ResourceNotFound" do
        it "returns a 404 error" do
          response = get("/i_dont_exist")
          response.should be_http(
            404,
            {},
            Regexp.new("File /i_dont_exist not found")
          )
        end
      end

      describe "PUT / - ResourceNotFound" do
        it "returns a 404 error" do
          response = put("/i_dont_exist")
          response.should be_http(
            404,
            {},
            Regexp.new("File /i_dont_exist not found")
          )
        end
      end

      describe "POST / - ResourceNotFound" do
        it "returns a 404 error" do
          response = post("/i_dont_exist")
          response.should be_http(
            404,
            {},
            Regexp.new("File /i_dont_exist not found")
          )
        end
      end

      describe "DELETE / - ResourceNotFound" do
        it "returns a 404 error" do
          response = delete("/i_dont_exist")
          response.should be_http(
            404,
            {},
            Regexp.new("File /i_dont_exist not found")
          )
        end
      end
    end
  end
end

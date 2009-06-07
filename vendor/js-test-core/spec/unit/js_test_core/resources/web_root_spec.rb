require File.expand_path("#{File.dirname(__FILE__)}/../../unit_spec_helper")

module JsTestCore
  module Resources
    describe WebRoot do
      describe "GET /" do
        it "includes a link to the spec suite" do
          response = get("/")
          response.should be_http(
            200,
            {},
            ""
          )
          doc = Nokogiri::HTML(response.body)
          doc.css("a[href='/specs']").should_not be_nil
        end
      end
    end
  end
end

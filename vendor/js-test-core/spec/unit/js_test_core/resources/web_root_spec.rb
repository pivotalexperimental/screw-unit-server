require File.expand_path("#{File.dirname(__FILE__)}/../../unit_spec_helper")

module JsTestCore
  module Resources
    describe WebRoot do
      macro("includes a link to the spec suite") do |relative_path|
        it "includes a link to the spec suite" do
          response = get(relative_path)
          response.should be_http(
            200,
            {},
            ""
          )
          doc = Nokogiri::HTML(response.body)
          doc.css("a[href='/specs']").should_not be_nil
        end
      end

      describe "GET " do
        send("includes a link to the spec suite", "")
      end

      describe "GET /" do
        send("includes a link to the spec suite", "/")
      end
    end
  end
end

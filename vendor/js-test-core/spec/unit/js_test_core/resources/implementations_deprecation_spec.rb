require File.expand_path("#{File.dirname(__FILE__)}/../../unit_spec_helper")

module JsTestCore
  module Resources
    describe ImplementationsDeprecation do
      describe "GET /implementations/*" do
        it "responds with a 301 to /javascripts/*" do
          response = get(ImplementationsDeprecation.path("/subdir/bar.js"))
          response.should be_http(
            301,
            {'Location' => File.path("/javascripts/subdir/bar.js")},
            "This page has been moved to #{File.path("/javascripts/subdir/bar.js")}"
          )
        end
      end
    end
  end
end
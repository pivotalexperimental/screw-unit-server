require File.expand_path("#{File.dirname(__FILE__)}/../../../unit_spec_helper")

module JsTestCore
  module Resources
    module Specs
      describe SpecFile do
        describe "GET" do
          describe "GET /specs/failing_spec" do
            it "renders a suite only for failing_spec.js as text/html" do
              absolute_path = "#{spec_root_path}/failing_spec.js"

              response = get(SpecFile.path("failing_spec"))
              response.should be_http(
                200,
                {
                  "Content-Type" => "text/html",
                  "Last-Modified" => ::File.mtime(absolute_path).rfc822
                },
                ""
              )
              doc = Nokogiri::HTML(response.body)
              js_files = doc.search("script").map {|script| script["src"]}
              js_files.should include("/specs/failing_spec.js")
            end
          end

          describe "GET /specs/failing_spec.js" do
            it "renders the contents of failing_spec.js as text/javascript" do
              absolute_path = "#{spec_root_path}/failing_spec.js"

              response = get(SpecFile.path("failing_spec.js"))
              response.should be_http(
                200,
                {
                  "Content-Type" => "text/javascript",
                  "Last-Modified" => ::File.mtime(absolute_path).rfc822
                },
                ::File.read(absolute_path)
              )
            end
          end

          describe "GET /specs/custom_suite" do
            it "renders the custom_suite.html file" do
              path = "#{spec_root_path}/custom_suite.html"

              response = get(SpecFile.path("custom_suite.html"))
              response.should be_http(
                200,
                {
                  "Content-Type" => "text/html",
                  "Last-Modified" => ::File.mtime(path).rfc822
                },
                ::File.read(path)
              )
            end
          end
        end
      end
    end
  end
end

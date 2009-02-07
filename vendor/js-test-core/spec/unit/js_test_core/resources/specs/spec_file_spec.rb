require File.expand_path("#{File.dirname(__FILE__)}/../../../unit_spec_helper")

module JsTestCore
  module Resources
    module Specs
      describe SpecFile do
        describe "GET" do
          before do
            WebRoot.dispatch_specs
          end

          describe "GET /specs/custom_suite.html" do
            it "renders the custom_suite.html file" do
              path = "#{spec_root_path}/custom_suite.html"
              mock(connection).send_head(200, 'Content-Type' => "text/html", 'Content-Length' => ::File.size(path), 'Last-Modified' => ::File.mtime(path).rfc822)
              mock(connection).send_data(::File.read(path))

              connection.receive_data("GET /specs/custom_suite.html HTTP/1.1\r\nHost: _\r\n\r\n")
            end
          end

          describe "GET /specs/foo/passing_spec" do
            it "renders a Representations::Spec with passing_spec.js as the spec file" do
              path = "#{spec_root_path}/foo/passing_spec.js"
              mock(connection).send_head(200, 'Content-Type' => "text/html", 'Content-Length' => ::File.size(path), 'Last-Modified' => ::File.mtime(path).rfc822)
              mock(connection).send_data(Regexp.new("Js Test Core Suite")) do |html|
                doc = Nokogiri::HTML(html)
                js_files = doc.search("script").map {|script| script["src"]}
                js_files.should include("/specs/foo/passing_spec.js")
                js_files.should_not include("/specs/foo/failing_spec.js")
              end

              connection.receive_data("GET /specs/foo/passing_spec HTTP/1.1\r\nHost: _\r\n\r\n")
            end
          end
        end
      end
    end
  end
end

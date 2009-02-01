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
            context "when #get_js is not overridden" do
              it "renders an InternalServerError" do
                Thin::Logging.silent = true
                path = "#{spec_root_path}/foo/passing_spec.js"
                mock(connection).send_head(500)
                stub(connection).send_data
                mock(connection).send_data(Regexp.new("#get_js needs to be implemented"))

                connection.receive_data("GET /specs/foo/passing_spec HTTP/1.1\r\nHost: _\r\n\r\n")
              end
            end
          end
        end
      end
    end
  end
end

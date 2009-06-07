require File.expand_path("#{File.dirname(__FILE__)}/../../../unit_spec_helper")

module JsTestCore
  module Resources
    module Specs
      describe SpecDir do
        attr_reader :dir, :absolute_path, :relative_path
        before do
          @absolute_path = spec_root_path
          @relative_path = "/specs"
          @dir = Resources::Specs::SpecDir.new(:connection => connection, :absolute_path => absolute_path, :relative_path => relative_path)
        end

        describe "GET /specs/foo" do
          it "renders a spec suite that includes all of the javascript spec files in the directory" do
            path = "#{spec_root_path}/foo"

            response = get(SpecDir.path("foo"))
            response.should be_http(
              200,
              {
                "Content-Type" => "text/html",
                "Last-Modified" => ::File.mtime(path).rfc822
              },
              ""
            )
            doc = Nokogiri::HTML(response.body)
            js_files = doc.search("script").map {|script| script["src"]}
            js_files.should include("/specs/foo/passing_spec.js")
            js_files.should include("/specs/foo/failing_spec.js")
          end
        end
      end
    end
  end
end

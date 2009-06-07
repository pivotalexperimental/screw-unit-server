require File.expand_path("#{File.dirname(__FILE__)}/../../unit_spec_helper")

module JsTestCore
  module Resources
    describe CoreFile do
      describe "Files" do
        describe "GET /core/JsTestCore.js" do
          it "renders the JsTestCore.js file, which lives in the core framework directory" do
            absolute_path = "#{core_path}/JsTestCore.js"

            response = get(CoreFile.path("JsTestCore.js"))
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
      end

      describe "Directories" do
        describe "GET /core/subdir" do
          it "returns a page with a of files in the directory" do
            response = get(CoreFile.path("subdir"))
            response.should be_http(
              200,
              {},
              %r(<a href="SubDirFile.js">SubDirFile.js</a>)
            )
          end
        end
      end
    end
  end
end

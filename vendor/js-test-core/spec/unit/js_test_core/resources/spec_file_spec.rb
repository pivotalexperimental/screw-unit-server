require File.expand_path("#{File.dirname(__FILE__)}/../../unit_spec_helper")

module JsTestCore
  module Resources
    describe SpecFile do
      describe "Configuration" do
        attr_reader :doc
        before do
          JsTestCore.framework_name = "screw-unit"
          JsTestCore::Representations::Suite.project_js_files += ["/javascripts/test_file_1.js", "/javascripts/test_file_2.js"]
          JsTestCore::Representations::Suite.project_css_files += ["/stylesheets/test_file_1.css", "/stylesheets/test_file_2.css"]

          response = get(SpecFile.path("/failing_spec"))
          response.should be_http( 200, {}, "" )

          @doc = Nokogiri::HTML(response.body)
        end

        after do
          JsTestCore::Representations::Suite.project_js_files.clear
          JsTestCore::Representations::Suite.project_css_files.clear
        end

        it "renders project js files" do
          doc.at("script[@src='/javascripts/test_file_1.js']").should_not be_nil
          doc.at("script[@src='/javascripts/test_file_2.js']").should_not be_nil
        end

        it "renders project css files" do
          doc.at("link[@href='/stylesheets/test_file_1.css']").should_not be_nil
          doc.at("link[@href='/stylesheets/test_file_2.css']").should_not be_nil
        end
      end

      describe "Files" do
        describe "GET /specs/failing_spec" do
          it "renders a suite only for failing_spec.js as text/html" do
            absolute_path = "#{spec_path}/failing_spec.js"

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
            absolute_path = "#{spec_path}/failing_spec.js"

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
            path = "#{spec_path}/custom_suite.html"

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

      describe "Directories" do
        describe "GET /specs" do
          macro "renders a suite for all specs" do |relative_path|
            it "renders a suite for all specs" do
              path = "#{spec_path}"

              response = get(relative_path)
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
              js_files.should include("/specs/failing_spec.js")
              js_files.should include("/specs/custom_dir_and_suite/passing_spec.js")
              js_files.should include("/specs/foo/passing_spec.js")
              js_files.should include("/specs/foo/failing_spec.js")
            end
          end

          send("renders a suite for all specs", SpecFile.path)
          send("renders a suite for all specs", SpecFile.path("/"))
        end

        describe "GET /specs/foo" do
          it "renders a spec suite that includes all of the javascript spec files in the directory" do
            path = "#{spec_path}/foo"

            response = get(SpecFile.path("foo"))
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

      describe "GET /specs/i_dont_exist" do
        it "renders a 404" do
          response = get(SpecFile.path("i_dont_exist"))
          response.should be_http(
            404,
            {},
            "/specs/i_dont_exist not found"
          )
        end
      end
    end
  end
end

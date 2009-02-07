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

        describe "#locate" do
          context "when passed the name with an extension" do
            context "when file exists" do
              it "returns a Resources::File representing it" do
                file = dir.locate("failing_spec.js")
                file.relative_path.should == "/specs/failing_spec.js"
                file.absolute_path.should == "#{spec_root_path}/failing_spec.js"
              end
            end

            context "when file does not exist" do
              it "raises error" do
                lambda { dir.locate("nonexistent.js") }.should raise_error
              end
            end
          end

          context "when passed a name without an extension" do
            context "when name corresponds to a subdirectory" do
              it "returns a DirectoryRunner for the directory" do
                subdir = dir.locate("foo")
                subdir.should == spec_dir("/foo")
              end
            end

            context "when name corresponds to a .js file" do
              it "returns a SpecFile for the .js file" do
                spec_file_name = "failing_spec"
                subdir = dir.locate(spec_file_name)
                subdir.should == JsTestCore::Resources::Specs::SpecFile.new(
                  :connection => connection,
                  :absolute_path => "#{spec_root_path}/#{spec_file_name}.js",
                  :relative_path => "/specs/#{spec_file_name}.js"
                )
              end
            end

            context "when name does not correspond to a .js file or directory" do
              it "raises an error" do
                lambda do
                  dir.locate("nonexistent")
                end.should raise_error
              end
            end
          end
        end

        describe "GET /specs/custom_dir_and_suite" do
          it "renders the custom_dir_and_suite.html file" do
            WebRoot.dispatch_specs
            path = "#{spec_root_path}/custom_dir_and_suite.html"
            mock(connection).send_head(200, 'Content-Type' => "text/html", 'Content-Length' => ::File.size(path), 'Last-Modified' => ::File.mtime(path).rfc822)
            mock(connection).send_data(::File.read(path))

            connection.receive_data("GET /specs/custom_dir_and_suite.html HTTP/1.1\r\nHost: _\r\n\r\n")
          end
        end

        describe "GET /specs/foo" do
          it "renders a custom spec suite that includes all of the javascript spec files in the directory" do
            WebRoot.dispatch_specs
            Thin::Logging.silent = true
            path = "#{spec_root_path}/foo"
            mock(connection).send_head(200, 'Content-Type' => "text/html", 'Last-Modified' => ::File.mtime(path).rfc822)
            mock(connection).send_data(/Content-Length: /)
            mock(connection).send_data(Regexp.new("Js Test Core Suite")) do |html|
              doc = Nokogiri::HTML(html)
              js_files = doc.search("script").map {|script| script["src"]}
              js_files.should include("/specs/foo/passing_spec.js")
              js_files.should include("/specs/foo/failing_spec.js")
            end

            connection.receive_data("GET /specs/foo HTTP/1.1\r\nHost: _\r\n\r\n")
          end
        end

        describe "GET /" do
          context "when WebRoot.dispatch_specs has been invoked" do
            it "renders a home page" do
              WebRoot.dispatch_specs
              mock(connection).send_head(200, :Location => '/specs')
              mock(connection).send_body(is_a(String))

              connection.receive_data("GET / HTTP/1.1\r\nHost: _\r\n\r\n")
            end
          end
        end
      end
    end
  end
end

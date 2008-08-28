require File.expand_path("#{File.dirname(__FILE__)}/../../unit_spec_helper")

module JsTestCore
  module Resources
    describe Dir do
      attr_reader :dir, :absolute_path, :relative_path

      describe "GET /stylesheets - Top level directory" do
        it "returns a page with a of files in the directory" do
          mock(connection).send_head()
          mock(connection).send_body(%r(<a href="example.css">example.css</a>))

          connection.receive_data("GET /stylesheets HTTP/1.1\r\nHost: _\r\n\r\n")
        end
      end

      describe "GET /javascripts/subdir - Subdirectory" do
        it "returns a page with a of files in the directory" do
          mock(connection).send_head()
          mock(connection).send_body(%r(<a href="bar.js">bar.js</a>))

          connection.receive_data("GET /javascripts/subdir HTTP/1.1\r\nHost: _\r\n\r\n")
        end
      end

      describe "#glob" do
        before do
          @absolute_path = spec_root_path
          @relative_path = "/specs"
          @dir = Resources::Dir.new(:connection => connection, :absolute_path => absolute_path, :relative_path => relative_path)
        end

        it "returns an array of matching Files under this directory with the correct relative paths" do
          globbed_files = dir.glob("/**/*_spec.js")
          globbed_files.size.should == 3
          globbed_files.should contain_spec_file_with_correct_paths("/failing_spec.js")
          globbed_files.should contain_spec_file_with_correct_paths("/foo/failing_spec.js")
          globbed_files.should contain_spec_file_with_correct_paths("/foo/passing_spec.js")
        end
      end
    end
  end
end

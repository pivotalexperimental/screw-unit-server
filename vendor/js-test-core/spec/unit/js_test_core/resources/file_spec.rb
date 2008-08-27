require File.expand_path("#{File.dirname(__FILE__)}/../../unit_spec_helper")

module JsTestCore
  module Resources
    describe File do
      before do
        WebRoot.dispatch_specs
        stub_send_data
        stub(EventMachine).close_connection
      end

      describe "GET /stylesheets/example.css" do
        it "returns a page with a of files in the directory" do
          mock(connection).send_head(200, 'Content-Type' => "text/css")
          mock(connection).send_body(::File.read("#{public_path}/stylesheets/example.css"))

          connection.receive_data("GET /stylesheets/example.css HTTP/1.1\r\nHost: _\r\n\r\n")
        end
      end

      describe "GET /implementations/foo.js" do
        it "returns a page with a of files in the directory" do
          mock(connection).send_head(200, 'Content-Type' => "text/javascript")
          mock(connection).send_body(::File.read("#{public_path}/javascripts/foo.js"))

          connection.receive_data("GET /implementations/foo.js HTTP/1.1\r\nHost: _\r\n\r\n")
        end
      end

      describe "==" do
        attr_reader :file, :absolute_path, :relative_path

        before do
          @absolute_path = "#{implementation_root_path}/foo.js"
          @relative_path = "/implementations/foo.js"
          @file = Resources::File.new(
            :connection => connection,
            :absolute_path => absolute_path,
            :relative_path => relative_path
          )
        end

        it "returns true when passed a file with the same absolute and relative paths" do
          file.should == Resources::File.new(:absolute_path => absolute_path, :relative_path => relative_path)
        end

        it "returns false when passed a file with a different absolute or relative path" do
          file.should_not == Resources::File.new(:absolute_path => absolute_path, :relative_path => "bogus")
          file.should_not == Resources::File.new(:absolute_path => "bogus", :relative_path => relative_path)
        end

        it "when passed a Dir, returns false because File is not a Dir" do
          file.should_not == Resources::Dir.new(:absolute_path => absolute_path, :relative_path => relative_path)
        end
      end
    end
  end
end
require File.expand_path("#{File.dirname(__FILE__)}/../../unit_spec_helper")

module JsTestCore
  module Resources
    describe File do
      attr_reader :request, :file

      before do
        WebRoot.dispatch_specs
        stub(EventMachine).send_data
        stub(EventMachine).close_connection
        @file = Resources::File.new(absolute_path, relative_path)
        @request = create_request('get', relative_path)
      end

      def absolute_path
        "#{spec_root_path}/failing_spec.js"
      end

      def relative_path
        "/specs/failing_spec.js"
      end

      describe "#absolute_path" do
        it "returns the absolute path passed into the initializer" do
          file.absolute_path.should == absolute_path
        end
      end

      describe "#relative_path" do
        it "returns the relative path passed into the initializer" do
          file.relative_path.should == relative_path
        end
      end

      describe "#get" do
        attr_reader :response
        before do
          @response = Rack::Response.new
        end

        it "returns the contents of the file" do
          file.get(request, response)
          response.body.should == ::File.read(absolute_path)
        end

        describe "when File has an extension" do
          describe '.js' do
            it "sets Content-Type to text/javascript" do
              file.get(request,response)
              response.content_type.should == "text/javascript"
            end
          end

          describe '.css' do
            it "sets Content-Type to text/css" do
              file.get(request, response)
              response.content_type.should == "text/css"
            end

            def absolute_path
              "#{core_path}/JsTestCore.css"
            end

            def relative_path
              "/core/JsTestCore.css"
            end
          end
        end
      end

      describe "==" do
        it "returns true when passed a file with the same absolute and relative paths" do
          file.should == Resources::File.new(absolute_path, relative_path)
        end

        it "returns false when passed a file with a different absolute or relative path" do
          file.should_not == Resources::File.new(absolute_path, "bogus")
          file.should_not == Resources::File.new("bogus", relative_path)
        end

        it "when passed a Dir, returns false because File is not a Dir" do
          file.should_not == Resources::Dir.new(absolute_path, relative_path)
        end
      end
    end
  end
end
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

            context "when name does not correspond to a .js file or directory" do
              it "raises an error" do
                lambda do
                  dir.locate("nonexistent")
                end.should raise_error
              end
            end
          end
        end

        describe "#get" do
          attr_reader :request, :response
          before do
            @request = Rack::Request.new( Rack::MockRequest.env_for('/core') )
            @response = Rack::Response.new
          end

          it "raises NotImplementedError" do
            lambda do
              dir.get
            end.should raise_error(NotImplementedError)
          end

          it "can be overridden from a Module without needing to redefine the #get method" do
            spec_dir_class = Resources::Specs::SpecDir.clone
            mod = Module.new do
              def get
              end
            end
            spec_dir_class.class_eval do
              include mod
            end
            @dir = spec_dir_class.new(:connection => connection, :absolute_path => absolute_path, :relative_path => relative_path)

            lambda do
              dir.get
            end.should_not raise_error
          end
        end

        describe "GET /" do
          context "when WebRoot.dispatch_specs has been invoked" do
            it "redirects to /specs" do
              WebRoot.dispatch_specs
              mock(connection).send_head(301, :Location => '/specs')
              mock(connection).send_body("<script type='text/javascript'>window.location.href='/specs';</script>")

              connection.receive_data("GET / HTTP/1.1\r\nHost: _\r\n\r\n")
            end
          end
        end
      end
    end
  end
end

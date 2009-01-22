require File.expand_path("#{File.dirname(__FILE__)}/../../../unit_spec_helper")

module JsTestCore
  module Resources
    module Specs
      describe SpecFile do
        attr_reader :file, :absolute_path, :relative_path, :request, :response
        before do
          @absolute_path = "#{spec_root_path}/failing_spec.js"
          @relative_path = "/specs/failing_spec.js"
          @file = Resources::Specs::SpecFile.new(:connection => connection, :absolute_path => absolute_path, :relative_path => relative_path)
          @request = Rack::Request.new( Rack::MockRequest.env_for(relative_path) )
          @response = Rack::Response.new
        end

        describe "#get" do
          it "raises NotImplementedError" do
            lambda do
              file.get
            end.should raise_error(NotImplementedError)
          end

          it "can be overridden from a Module without needing to redefine the #get method" do
            spec_file_class = Resources::Specs::SpecFile.clone
            mod = Module.new do
              def get
              end
            end
            spec_file_class.class_eval do
              include mod
            end
            @file = spec_file_class.new(:connection => connection, :absolute_path => absolute_path, :relative_path => relative_path)

            lambda do
              file.get
            end.should_not raise_error
          end
        end
      end
    end
  end
end

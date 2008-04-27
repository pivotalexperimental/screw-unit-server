require File.expand_path("#{File.dirname(__FILE__)}/../../unit_spec_helper")

module JsTestCore
  module Resources
    describe WebRoot do
      attr_reader :web_root
      before(:each) do
        @web_root = WebRoot.new(public_path)
      end

      describe "#locate" do
        it "when passed 'core', returns a Dir representing the JsTestCore core directory" do
          runner = web_root.locate('core')
          runner.should == Resources::Dir.new(JsTestCore::Server.core_path, '/core')
        end

        it "when passed 'implementations', returns a Dir representing the javascript implementations directory" do
          runner = web_root.locate('implementations')
          runner.should == Resources::Dir.new(JsTestCore::Server.implementation_root_path, '/implementations')
        end

        it "when passed 'results', returns a Suite" do
          runner = web_root.locate('suites')
          runner.should == Resources::Suite
        end

        it "when passed 'runners', returns a Runner" do
          runner = web_root.locate('runners')
          runner.should be_instance_of(Resources::Runners)
        end

        it "when passed a directory that is in the public_path, returns a Dir representing that directory" do
          runner = web_root.locate('stylesheets')
          runner.should == Resources::Dir.new("#{JsTestCore::Server.public_path}/stylesheets", '/stylesheets')
        end

        it "when passed a file that is in the public_path, returns a File representing that file" do
          runner = web_root.locate('robots.txt')
          runner.should == Resources::File.new("#{JsTestCore::Server.public_path}/robots.txt", '/robots.txt')
        end

        it "when not passed 'core' or 'specs', raises an error" do
          lambda do
            web_root.locate('invalid')
          end.should raise_error
        end
      end

      describe ".dispatch_specs" do
        it "causes #locate /specs to dispatch to a Spec::SpecDir" do
          WebRoot.dispatch_specs
          
          resource = web_root.locate('specs')
          resource.should == spec_dir('')
        end
      end

      describe "when .dispatch_specs is not called" do
        it "does not cause #locate to dispatch to /specs" do
          lambda do
            web_root.locate('specs')
          end.should raise_error
        end
      end
    end
  end
end

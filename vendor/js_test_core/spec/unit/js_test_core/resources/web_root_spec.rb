require File.expand_path("#{File.dirname(__FILE__)}/../../unit_spec_helper")

module JsTestCore
  module Resources
    describe WebRoot do
      attr_reader :web_root
      before(:each) do
        @web_root = WebRoot.new(public_path)
      end

      describe "#locate" do
        describe "when passed ''" do
          it "returns self" do
            web_root.locate('').should == web_root
          end
        end

        describe "when passed 'core'" do
          it "returns a Dir representing the JsTestCore core directory" do
            runner = web_root.locate('core')
            runner.should == Resources::Dir.new(JsTestCore::Server.core_path, '/core')
          end
        end

        describe "when passed 'implementations'" do
          it "returns a Dir representing the javascript implementations directory" do
            runner = web_root.locate('implementations')
            runner.should == Resources::Dir.new(JsTestCore::Server.implementation_root_path, '/implementations')
          end
        end

        describe "when passed 'results'" do
          it "returns a Suite" do
            runner = web_root.locate('suites')
            runner.should == Resources::Suite
          end
        end

        describe "when passed 'runners'" do
          it "returns a Runner" do
            runner = web_root.locate('runners')
            runner.should be_instance_of(Resources::Runners)
          end
        end

        describe "when passed a directory that is in the public_path" do
          it "returns a Dir representing that directory" do
            runner = web_root.locate('stylesheets')
            runner.should == Resources::Dir.new("#{JsTestCore::Server.public_path}/stylesheets", '/stylesheets')
          end
        end

        describe "when passed a file that is in the public_path" do
          it "returns a File representing that file" do
            runner = web_root.locate('robots.txt')
            runner.should == Resources::File.new("#{JsTestCore::Server.public_path}/robots.txt", '/robots.txt')
          end
        end

        describe "when passed an invalid option" do
          it "returns a 404 response" do
            resource = web_root.locate('invalid')
            
          end
        end
      end

      describe ".dispatch_specs" do
        describe "#get" do
          attr_reader :request, :response
          before do
            @request = Rack::Request.new({'rack.input' => StringIO.new("")})
            @response = Rack::Response.new
          end

          it "redirects to /specs" do
            WebRoot.dispatch_specs

            web_root.get(request, response)
            response.should be_redirect
            response.headers["Location"].should == "/specs"
          end
        end

        describe "#locate /specs" do
          it "dispatches to a Spec::SpecDir" do
            WebRoot.dispatch_specs

            resource = web_root.locate('specs')
            resource.should == spec_dir('')
          end
        end

      end

      describe "when .dispatch_specs is not called" do
        it "does not cause #locate to dispatch to /specs" do
          web_root.locate('specs').should be_instance_of(FileNotFound)
        end
      end
    end
  end
end

require File.expand_path("#{File.dirname(__FILE__)}/../unit_spec_helper")

module JsTestCore
  describe Configuration do
    attr_reader :result
    
    before do
      @result = ""
    end

    describe "#spec_root" do
      it "returns the Dir " do
        Configuration.spec_path.should == spec_path
      end
    end

    describe "#spec_path" do
      it "returns the absolute path of the specs root directory" do
        Configuration.spec_path.should == spec_path
      end
    end

    describe "#root_path" do
      it "returns the expanded path of the public path" do
        Configuration.root_path.should == root_path
      end
    end

    describe "#framework_path" do
      it "returns the expanded path to the JsTestCore core directory" do
        Configuration.framework_path.should == framework_path
      end
    end
    
    describe "#js_test_core_js_path" do
      it "returns the path to js_test_core.js" do
        ::File.read(Configuration.js_test_core_js_path).should include("function JsTestServer()")
      end
    end
    
    describe "#root_url" do
      it "returns the url of the site's root" do
        configuration = Configuration.new
        configuration.host = "localhost"
        configuration.port = 9999
        configuration.root_url.should == "http://localhost:9999"
      end
    end
  end
end
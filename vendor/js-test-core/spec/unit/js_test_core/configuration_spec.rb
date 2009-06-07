require File.expand_path("#{File.dirname(__FILE__)}/../unit_spec_helper")

module JsTestCore
  describe Configuration do
    attr_reader :result
    
    before do
      @result = ""
    end

    describe ".spec_root" do
      it "returns the Dir " do
        Configuration.spec_root_path.should == spec_root_path
      end
    end

    describe ".spec_root_path" do
      it "returns the absolute path of the specs root directory" do
        Configuration.spec_root_path.should == spec_root_path
      end
    end

    describe ".public_path" do
      it "returns the expanded path of the public path" do
        Configuration.public_path.should == public_path
      end
    end

    describe ".core_path" do
      it "returns the expanded path to the JsTestCore core directory" do
        Configuration.core_path.should == core_path
      end
    end

    describe ".implementation_root_path" do
      it "returns the expanded path to the JsTestCore javascripts directory" do
        dir = ::File.dirname(__FILE__)
        Configuration.implementation_root_path.should == implementation_root_path
      end
    end

    describe "#root_url" do
      it "returns the url of the site's root" do
        server = Configuration.new
        server.host = "localhost"
        server.port = 9999
        server.root_url.should == "http://localhost:9999"
      end
    end
  end
end
require File.expand_path("#{File.dirname(__FILE__)}/../unit_spec_helper")

module JsTestCore
  describe Server do
    describe ".standalone_rackup" do
      attr_reader :builder
      before do
        stub(Server).puts
        @builder = "builder"
      end

      context "when passed a nil spec_root_path and a nil public_path" do
        it "defaults spec_root_path to ./spec/javascripts and public_path to ./public" do
          expected_spec_root_path = File.expand_path("./spec/javascripts")
          mock(File).directory?( expected_spec_root_path) {true}
          expected_public_path = File.expand_path("./public")
          mock(File).directory?( expected_public_path) {true}
          mock(builder).use(JsTestCore::App)
          mock(builder).run(Sinatra::Application)

          Server.standalone_rackup(builder, nil, nil)

          JsTestCore.spec_root_path.should == File.expand_path(expected_spec_root_path)
          JsTestCore.public_path.should == File.expand_path(expected_public_path)
        end
      end

      context "when the spec_root_path is not a directory" do
        it "raises an ArgumentError" do
          mock(File).directory?("spec_root_path") {false}

          lambda do
            Server.standalone_rackup(builder, "spec_root_path", nil)
          end.should raise_error(ArgumentError)
        end
      end

      context "when the public_path is not a directory" do
        it "raises an ArgumentError" do
          mock(File).directory?("spec_root_path") {true}
          mock(File).directory?("public_path") {false}

          lambda do
            Server.standalone_rackup(builder, "spec_root_path", "public_path")
          end.should raise_error(ArgumentError)
        end
      end
    end
  end
end
require File.expand_path("#{File.dirname(__FILE__)}/../../unit_spec_helper")

module JsTestCore
  module Resources
    describe Dir do
      attr_reader :dir, :absolute_path, :relative_path

      describe "#locate" do
        before do
          @absolute_path = core_path
          @relative_path = "/core"
          @dir = Resources::Dir.new(absolute_path, relative_path)
        end

        describe "when passed a name of a real file" do
          it "returns a Resources::File representing it" do
            file = dir.locate("JsTestCore.css")
            file.relative_path.should == "/core/JsTestCore.css"
            file.absolute_path.should == "#{core_path}/JsTestCore.css"
          end
        end
      end

      describe "#glob" do
        before do
          @absolute_path = spec_root_path
          @relative_path = "/specs"
          @dir = Resources::Dir.new(absolute_path, relative_path)
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

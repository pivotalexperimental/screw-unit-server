require File.expand_path("#{File.dirname(__FILE__)}/unit_spec_helper")

module JsTestCore
  module Resources
    module Specs
      describe SpecFile do
        describe "File" do
          describe "GET /specs/failing_spec" do
            attr_reader :doc

            context "when using the default .jquery_js_file" do
              before do
                ScrewUnit::Representations::Spec.project_js_files += ["/javascripts/test_file_1.js", "/javascripts/test_file_2.js"]
                ScrewUnit::Representations::Spec.project_css_files += ["/stylesheets/test_file_1.css", "/stylesheets/test_file_2.css"]

                response = get(SpecFile.path("/failing_spec"))
                response.should be_http( 200, {}, "" )

                @doc = Nokogiri::HTML(response.body)
              end

              after do
                ScrewUnit::Representations::Spec.project_js_files.clear
                ScrewUnit::Representations::Spec.project_css_files.clear
              end

              it "returns script tags for the test javascript file" do
                doc.at("script[@src='/specs/failing_spec.js']").should_not be_nil
              end

              it "renders the screw unit template" do
                doc.at("link[@href='/core/screw.css']").should_not be_nil
                doc.at("script[@src='/core/screw.builder.js']").should_not be_nil
                doc.at("script[@src='/core/screw.events.js']").should_not be_nil
                doc.at("script[@src='/core/screw.behaviors.js']").should_not be_nil
                doc.at("body/#screw_unit_content").should_not be_nil
              end

              it "renders project js files" do
                doc.at("script[@src='/javascripts/test_file_1.js']").should_not be_nil
                doc.at("script[@src='/javascripts/test_file_2.js']").should_not be_nil
              end

              it "renders project css files" do
                doc.at("link[@href='/stylesheets/test_file_1.css']").should_not be_nil
                doc.at("link[@href='/stylesheets/test_file_2.css']").should_not be_nil
              end
            end

            context "when using a custom .jquery_js_file" do
              attr_reader :default_jquery_js_file
              before do
                @default_jquery_js_file = ScrewUnit::Representations::Spec.jquery_js_file
                ScrewUnit::Representations::Spec.jquery_js_file = "/javascripts/jquery-6.6.6.js"
                default_jquery_js_file.should_not == ScrewUnit::Representations::Spec.jquery_js_file

                response = get(SpecFile.path("/failing_spec"))
                response.should be_http( 200, {}, "" )

                @doc = Nokogiri::HTML(response.body)
              end

              it "renders the custom jquery file" do
                doc.at("script[@src='/javascripts/jquery-6.6.6.js']").should_not be_nil
                doc.at("script[@src='#{default_jquery_js_file}']").should be_nil
              end
            end
          end
        end

        describe "Directory" do
          describe "GET /specs" do
            attr_reader :dir, :html, :doc

            before do
              response = get(SpecFile.path("/"))
              response.should be_http(
                200,
                {},
                ""
              )

              @doc = Nokogiri::HTML(response.body)
            end

            it "returns script tags for each test javascript file" do
              doc.at("script[@src='/specs/failing_spec.js']").should_not be_nil
              doc.at("script[@src='/specs/foo/failing_spec.js']").should_not be_nil
              doc.at("script[@src='/specs/foo/passing_spec.js']").should_not be_nil
            end

            it "returns the screw unit template" do
              doc.at("link[@href='/core/screw.css']").should_not be_nil
              doc.at("script[@src='/core/screw.builder.js']").should_not be_nil
              doc.at("script[@src='/core/screw.events.js']").should_not be_nil
              doc.at("script[@src='/core/screw.behaviors.js']").should_not be_nil
              doc.at("body/#screw_unit_content").should_not be_nil
            end
          end
        end
      end
    end
  end
end
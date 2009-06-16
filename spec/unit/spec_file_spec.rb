require File.expand_path("#{File.dirname(__FILE__)}/unit_spec_helper")

module JsTestCore
  module Resources
    module Specs
      describe SpecFile do
        describe "File" do
          describe "GET /specs/failing_spec" do
            attr_reader :html, :doc
            before do
              response = get(SpecFile.path("/failing_spec"))
              response.should be_http(
                200,
                {},
                ""
              )

              @doc = Nokogiri::HTML(response.body)
            end

            it "returns script tags for the test javascript file" do
              doc.at("script[@src='/specs/failing_spec.js']").should_not be_nil
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
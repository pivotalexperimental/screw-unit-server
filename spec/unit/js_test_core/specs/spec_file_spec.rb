require File.expand_path("#{File.dirname(__FILE__)}/../../unit_spec_helper")

module JsTestCore
  module Resources
    module Specs
      describe SpecFile do
        describe "#spec_files" do
          attr_reader :absolute_path, :relative_path, :file

          before do
            @absolute_path = "#{spec_root_path}/failing_spec.js"
            @relative_path = "/specs/failing_spec.js"
            @file = SpecFile.new(absolute_path, relative_path)
          end

          describe "#get" do
            attr_reader :html, :doc
            before do
              request = request('get', '/specs')
              response = Rack::Response.new
              file.get(request, response)
              @html = response.body
              @doc = Hpricot(html)
            end

            it "returns script tags for the test javascript file" do
              doc.at("script[@src='/specs/failing_spec.js']").should exist
            end

            it "returns the screw unit template" do
              doc.at("link[@href='/core/screw.css']").should exist
              doc.at("script[@src='/core/screw.builder.js']").should exist
              doc.at("script[@src='/core/screw.events.js']").should exist
              doc.at("script[@src='/core/screw.behaviors.js']").should exist
              doc.at("body/#screw_unit_content").should_not be_nil
            end
          end
        end
      end
    end
  end
end
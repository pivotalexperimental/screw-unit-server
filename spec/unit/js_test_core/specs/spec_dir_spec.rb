require File.expand_path("#{File.dirname(__FILE__)}/../../unit_spec_helper")

module JsTestCore
  module Resources
    module Specs
      describe SpecDir do

        describe "GET /specs" do
          attr_reader :dir, :html, :doc

          before do
            mock(connection).send_head
            mock(connection).send_body(anything) do |@html|
              # do nothing
            end

            connection.receive_data("GET /specs HTTP/1.1\r\nHost: _\r\n\r\n")
            @doc = Hpricot(html)
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
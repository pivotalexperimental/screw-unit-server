require File.expand_path("#{File.dirname(__FILE__)}/../../unit_spec_helper")

module JsTestCore
  module Resources
    describe FileNotFound do
      describe "GET /invalid_path" do
        it "returns a page with a of files in the directory" do
          mock(connection).send_head(404)
          mock(connection).send_body("")

          connection.receive_data("GET /invalid_path HTTP/1.1\r\nHost: _\r\n\r\n")
        end
      end
    end
  end
end
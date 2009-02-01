require File.expand_path("#{File.dirname(__FILE__)}/../../thin_rest_spec_helper")

module ThinRest
  module Resources
    describe ResourceNotFound do
      describe "GET /invalid_path" do
        it "returns a page with a of files in the directory" do
          mock(connection).send_head(404)
          mock(connection).send_body(Regexp.new("File /invalid_path not found."))

          connection.receive_data("GET /invalid_path HTTP/1.1\r\nHost: _\r\n\r\n")
        end
      end
    end
  end
end
require File.expand_path("#{File.dirname(__FILE__)}/../../unit_spec_helper")

module JsTestCore
  module Resources
    describe WebRoot do
      attr_reader :web_root
      before(:each) do
        @web_root = WebRoot.new(:connection => connection, :public_path => public_path)
      end

      describe "GET /stylesheets" do
        it "returns a page with a of files in the directory" do
          mock(connection).send_head()
          mock(connection).send_body(Regexp.new('<a href="example.css">example.css</a>'))

          connection.receive_data("GET /stylesheets HTTP/1.1\r\nHost: _\r\n\r\n")
        end
      end

      describe "GET /stylesheets/example.css" do
        it "returns a page with a of files in the directory" do
          path = "#{public_path}/stylesheets/example.css"
          mock(connection).send_head(200, 'Content-Type' => "text/css", 'Content-Length' => ::File.size(path))
          mock(connection).send_data(::File.read(path))
          stub(EventMachine).close_connection

          connection.receive_data("GET /stylesheets/example.css HTTP/1.1\r\nHost: _\r\n\r\n")
        end
      end
    end
  end
end

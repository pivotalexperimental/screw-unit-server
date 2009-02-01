require File.expand_path("#{File.dirname(__FILE__)}/../../thin_rest_spec_helper")

module ThinRest
  module Resources
    describe Resource do
      attr_reader :root
      self.thin_logging = true
      before do
        stub(EventMachine).close_connection
        @root = Root.new(:connection => connection)
      end

      describe ".property" do
        it "creates a reader that takes its value from its env property" do
          root.env[:connection].should == connection
          root.connection.should == root.env[:connection]
        end

        it "creates a writer that sets its passed in value to its env property" do
          another_connection = create_connection
          root.connection = another_connection
          root.connection.should == another_connection
          root.env[:connection].should == another_connection
        end
      end

      describe "#locate" do
        context "/subresource - route is defined using a String" do
          it "returns an instance of Subresource" do
            root.locate("subresource").class.should == Subresource
          end
        end

        context "/block_subresource - route is defined using a block" do
          it "returns an instance of BlockSubresource" do
            root.locate("block_subresource").class.should == BlockSubresource
          end

          it "executes the block within the instance of the Resource" do
            root.foobar.should_not be_nil
            root.locate("block_subresource").foobar.should == root.foobar
          end
        end

        context "/no_handler_subresource - route is not defined" do
          it "returns a ResourceNotFound resource" do
            root.locate("no_handler_subresource").class.should == Resources::ResourceNotFound
          end
        end

        context "/wrong_property - passed in property not defined" do
          it "does not set an instance variable named after the wrong property" do
            resource = root.locate("wrong_property")
            resource.env.should == {:connection => connection, :baz => "wrong_property"}
            resource.instance_variable_get("@connection").should == connection
            resource.instance_variable_get("@baz").should be_nil
          end
        end
      end

      describe "Delegations" do
        describe "#request" do
          it "delegates to #connection" do
            root.request.should == connection.request
          end
        end

        describe "#response" do
          it "delegates to #connection" do
            root.response.should == connection.response
          end
        end

        describe "#rack_request" do
          it "delegates to #connection" do
            root.rack_request.should == connection.rack_request
          end
        end
      end

      describe "GET /subresource" do
        it "sends the GET response for the resource" do
          mock(connection).send_data(connection.head(200, {}))
          expected_data = "GET response"
          expected_content_length = "Content-Length: #{expected_data.length}\r\n\r\n"
          mock(connection).send_data(expected_content_length) {expected_content_length.length}
          mock(connection).send_data(expected_data) {expected_data.length}
          connection.receive_data("GET /subresource HTTP/1.1\r\nHost: _\r\n\r\n")
        end
      end

      describe "GET /no_handler_subresource" do
        it "renders an error page and logs the error" do
          stub(connection).send_data
          mock(connection).send_data(Regexp.new("File /no_handler_subresource not found"))
          mock(connection).log_error(is_a(ThinRest::RoutingError))
          connection.receive_data("GET /no_handler_subresource HTTP/1.1\r\nHost: _\r\n\r\n")
        end
      end

      describe "POST /subresource" do
        it "sends the POST response for the resource" do
          mock(connection).send_data(connection.head(200, {}))
          expected_data = "POST response"
          expected_content_length = "Content-Length: #{expected_data.length}\r\n\r\n"
          mock(connection).send_data(expected_content_length) {expected_content_length.length}
          mock(connection).send_data(expected_data) {expected_data.length}
          connection.receive_data("POST /subresource HTTP/1.1\r\nHost: _\r\n\r\n")
        end
      end

      describe "PUT /subresource" do
        it "sends the PUT response for the resource" do
          mock(connection).send_data(connection.head(200, {}))
          expected_data = "PUT response"
          expected_content_length = "Content-Length: #{expected_data.length}\r\n\r\n"
          mock(connection).send_data(expected_content_length) {expected_content_length.length}
          mock(connection).send_data(expected_data) {expected_data.length}
          connection.receive_data("PUT /subresource HTTP/1.1\r\nHost: _\r\n\r\n")
        end
      end

      describe "DELETE /subresource" do
        it "sends the DELETE response for the resource" do
          mock(connection).send_data(connection.head(200, {}))
          expected_data = "DELETE response"
          expected_content_length = "Content-Length: #{expected_data.length}\r\n\r\n"
          mock(connection).send_data(expected_content_length) {expected_content_length.length}
          mock(connection).send_data(expected_data) {expected_data.length}
          connection.receive_data("DELETE /subresource HTTP/1.1\r\nHost: _\r\n\r\n")
        end
      end
    end
  end
end

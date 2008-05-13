module Thin
  module Backends
    class JsTestCoreServer < TcpServer
      def connect
        @signature = EventMachine.start_server(@host, @port, JsTestCoreConnection, &method(:initialize_connection))
      end
    end
  end
end
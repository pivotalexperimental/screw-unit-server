module JsTestCore
  class Server
    class << self
      attr_accessor :instance

      def run(spec_root_path, implementation_root_path, public_path, server_options = {})
        server_options[:Host] ||= DEFAULT_HOST
        server_options[:Port] ||= DEFAULT_PORT
        @instance = new(spec_root_path, implementation_root_path, public_path, server_options[:Host], server_options[:Port])
        instance.run server_options
      end

      def spec_root_path; instance.spec_root_path; end
      def implementation_root_path; instance.implementation_root_path; end
      def public_path; instance.public_path; end
      def core_path; instance.core_path; end
      def request; instance.request; end
      def response; instance.response; end
      def root_url; instance.root_url; end
    end

    attr_reader :host, :port, :spec_root_path, :implementation_root_path, :public_path

    def initialize(spec_root_path, implementation_root_path, public_path, host=DEFAULT_HOST, port=DEFAULT_PORT)
      dir = ::File.dirname(__FILE__)
      @spec_root_path = ::File.expand_path(spec_root_path)
      @implementation_root_path = ::File.expand_path(implementation_root_path)
      @public_path = ::File.expand_path(public_path)
      @host = host
      @port = port
    end

    def run(options)
      server = ::Thin::Server.new(options[:Host], options[:Port]) do
        use Rack::CommonLogger
      end
      server.backend = ::Thin::Backends::JsTestCoreServer.new(options[:Host], options[:Port])
      server.backend.server = server
      server.start!
    end

    def root_url
      "http://#{host}:#{port}"
    end

    def core_path
      JsTestCore.core_path
    end
  end
end
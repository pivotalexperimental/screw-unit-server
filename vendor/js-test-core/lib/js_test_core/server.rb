module JsTestCore
  class Server
    class << self
      attr_writer :instance
      def instance
        @instance ||= new
      end
    end

    DEFAULTS = {
      :host => "0.0.0.0",
      :port => 8080,
      :spec_path => File.expand_path("./spec/javascripts"),
      :root_path => File.expand_path("./public"),
    }

    def cli(*argv)
      opts = Trollop.options(argv) do
        opt(
          :framework_name,
          "The name of the test framework you want to use. e.g. --framework-name=jasmine",
          :type => String,
          :default => DEFAULTS[:framework_name]
        )
        opt(
          :framework_path,
          "The name of the test framework you want to use. e.g. --framework-path=./specs/jasmine_core",
          :type => String,
          :default => DEFAULTS[:framework_path]
        )
        opt(
          :spec_path,
          "The path to the spec files. e.g. --spec-path=./specs",
          :type => String,
          :default => DEFAULTS[:spec_path]
        )
        opt(
          :root_path,
          "The root path of the server. e.g. --root-path=./public",
          :type => String,
          :default => DEFAULTS[:root_path]
        )
        opt(
          :port,
          "The server port",
          :type => Integer,
          :default => DEFAULTS[:port]
        )
      end

      JsTestCore.port = opts[:port]
      JsTestCore.framework_name = opts[:framework_name]
      JsTestCore.framework_path = opts[:framework_path]
      JsTestCore.spec_path = opts[:spec_path]
      JsTestCore.root_path = opts[:root_path]
      STDOUT.puts "root-path is #{JsTestCore.root_path}"
      STDOUT.puts "spec-path is #{JsTestCore.spec_path}"
      start
    end

    def start
      require "thin"
      Thin::Runner.new([
        "--port", JsTestCore.port.to_s,
        "--rackup", File.expand_path(rackup_path),
        "start"]
      ).run!
    end

    def standalone_rackup(rack_builder)
      require "sinatra"

      rack_builder.use JsTestCore::App
      rack_builder.run Sinatra::Application
    end

    protected

    def rackup_path
      dir = File.dirname(__FILE__)
      File.expand_path("#{dir}/../../standalone.ru")
    end
  end
end
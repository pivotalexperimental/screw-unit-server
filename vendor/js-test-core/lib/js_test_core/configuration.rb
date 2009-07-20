module JsTestCore
  class Configuration
    class << self
      attr_accessor :instance

      def method_missing(method_name, *args, &block)
        if Configuration.instance.respond_to?(method_name)
          Configuration.instance.send(method_name, *args, &block)
        else
          super
        end
      end
    end

    attr_reader :host, :port, :spec_path, :root_path, :framework_path, :framework_name
    attr_writer :host, :port, :framework_path, :framework_name

    def initialize(params={})
      params = Server::DEFAULTS.dup.merge(params)
      @spec_path = ::File.expand_path(params[:spec_path])
      @root_path = ::File.expand_path(params[:root_path])
      @host = params[:host]
      @port = params[:port]
      @framework_path = params[:framework_path]
      @framework_name = params[:framework_name]
    end

    def suite_representation_class
      if framework_name
        JsTestCore::Representations::Suites.const_get(framework_name.gsub("-", "_").camelcase)
      end
    end

    def spec_path=(path)
      validate_path(path)
      @spec_path = path
    end

    def root_path=(path)
      validate_path(path)
      @root_path = path
    end

    def root_url
      "http://#{host}:#{port}"
    end

    protected

    def validate_path(path)
      unless File.directory?(path)
        raise ArgumentError, "#{path} must be a directory"
      end
    end
  end
end
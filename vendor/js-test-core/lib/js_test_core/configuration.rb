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

    attr_accessor :host, :port, :spec_root_path, :implementation_root_path, :public_path, :core_path

    def initialize(params={})
      params = {
        :spec_root_path => File.expand_path("./specs/javascripts"),
        :implementation_root_path => File.expand_path("./public/javascripts"),
        :public_path => File.expand_path("./public"),
        :host => DEFAULT_HOST,
        :port => DEFAULT_PORT,
      }.merge(params)
      @spec_root_path = ::File.expand_path(params[:spec_root_path])
      @implementation_root_path = ::File.expand_path(params[:implementation_root_path])
      @public_path = ::File.expand_path(params[:public_path])
      @host = params[:host]
      @port = params[:port]
      @core_path = params[:core_path]
    end

    def root_url
      "http://#{host}:#{port}"
    end
  end
end
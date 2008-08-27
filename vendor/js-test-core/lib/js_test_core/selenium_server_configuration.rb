module JsTestCore
  class SeleniumServerConfiguration
    attr_reader :parameters

    class << self
      def query_string_from(*args, &block)
        new(*args, &block).query_string
      end
    end

    def initialize(parameters={})
      @parameters = parameters
    end


    def query_string
      parts = [selenium_host, selenium_port]
      parts << spec_url if url
      parts.join('&')
    end

    private

    def selenium_host
      "selenium_host=#{parameter_or_default_for(:selenium_host, 'localhost')}"
    end

    def selenium_port
      "selenium_port=#{parameter_or_default_for(:selenium_port, 4444)}"
    end

    def spec_url
      "spec_url=#{url}"
    end

    def url
      parameters[:spec_url]
    end

    def parameter_or_default_for(parameter_name, default = nil)
      CGI.escape((parameters[parameter_name] || default).to_s)
    end
  end
end

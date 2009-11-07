module LuckyLuciano
  class Resource
    class << self
      attr_reader :base_path_definition

      def map(base_path_definition)
        @base_path_definition = base_path_definition
      end

      def recorded_http_handlers
        @recorded_http_handlers ||= []
      end

      def route_handler
        create_sinatra_handler
      end

      ["get", "put", "post", "delete"].each do |http_verb|
        class_eval(<<-RUBY, __FILE__, __LINE__ + 1)
        def #{http_verb}(relative_path, opts={}, &block)
          recorded_http_handlers << [:#{http_verb}, relative_path, opts, block]
        end
        RUBY
      end

      def [](sub_path=nil)
        Path.new(self, sub_path)
      end

      def path(*sub_paths)
        params = sub_paths.last.is_a?(Hash) ? sub_paths.pop : {}

        sub_path_definition = sub_paths.join("/")

        full_path = normalize_seperators("#{base_path(params)}/#{path_from_definition(sub_path_definition, params)}").gsub(/\/$/, "")

        base_path_param_keys = param_keys_from(base_path_definition)
        query_params = params.delete_if do |key, value|
          base_path_param_keys.include?(key)
        end

        sub_path_param_keys = param_keys_from(sub_path_definition)
        query_params = params.delete_if do |key, value|
          sub_path_param_keys.include?(key)
        end

        if query_params.empty?
          full_path
        else
          query = build_query(query_params)
          "#{full_path}?#{query}"
        end
      end

      def base_path(params={})
        path_from_definition(base_path_definition, params)
      end

      def normalize_seperators(url)
        url.gsub(Regexp.new("//+"), '/')
      end

      protected

      def path_from_definition(definition, params={})
        param_keys = param_keys_from(definition)
        if param_keys.empty?
          definition.dup
        else
          param_keys.each do |base_path_param|
            unless params.include?(base_path_param.to_sym)
              raise ArgumentError, "Expected #{base_path_param.inspect} to have a value"
            end
          end
          definition.split("/").map do |segment|
            if param_key = segment_param_key(segment)
              params[param_key]
            else
              segment
            end
          end.join("/")
        end
      end

      def param_keys_from(definition)
        definition.split("/").find_all do |segment|
          segment_param_key(segment)
        end.map do |param|
          param[1..-1].to_sym
        end
      end

      def segment_param_key(segment)
        segment[0..0] == ':' ? segment[1..-1].to_sym : nil
      end

      def build_query(params)
        params.to_a.inject([]) do |splatted_params, (key, value)|
          [value].flatten.each do |value_in_param|
            splatted_params << "#{URI.escape(key.to_s)}=#{URI.escape(value_in_param.to_s)}"
          end
          splatted_params
        end.join("&")
      end

      def create_sinatra_handler
        resource_class = self
        Module.new do
          (class << self; self; end).class_eval do
            define_method(:registered) do |app|
              resource_class.recorded_http_handlers.each do |handler|
                verb, relative_path, opts, block = handler
                full_path = resource_class.normalize_seperators(
                  "#{resource_class.base_path_definition}/#{relative_path}"
                ).gsub(%r{^.+/$}) do |match|
                    match.gsub(%r{/$}, "")
                end
                app.send(verb, full_path, opts) do
                  resource_class.new(self).instance_eval(&block)
                end
              end
            end
          end
        end
      end
    end

    attr_reader :app

    def initialize(app)
      @app = app
    end

    def method_missing(method_name, *args, &block)
      if app.respond_to?(method_name)
        app.send(method_name, *args, &block)
      else
        super
      end
    end
  end
end
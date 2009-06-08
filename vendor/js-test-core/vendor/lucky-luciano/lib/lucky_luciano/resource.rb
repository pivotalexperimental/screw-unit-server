module LuckyLuciano
  class Resource
    class << self
      attr_reader :base_path_definition, :base_path_param_keys

      def map(base_path_definition)
        @base_path_definition = base_path_definition
        @base_path_param_keys = base_path_definition.split("/").find_all do |segment|
          segment_param_key(segment)
        end.map do |param|
          param[1..-1].to_sym
        end
        @base_path_definition
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

      def path(*sub_paths)
        params = sub_paths.last.is_a?(Hash) ? sub_paths.pop : {}

        full_path = "#{base_path(params)}/#{sub_paths.join("/")}".gsub("//", "/").gsub(/\/$/, "")

        query_params = params.delete_if do |key, value|
          base_path_param_keys.include?(key)
        end

        if query_params.empty?
          full_path
        else
          query = build_query(query_params)
          "#{full_path}?#{query}"
        end
      end

      def base_path(params={})
        base_path = if base_path_param_keys.empty?
          base_path_definition.dup
        else
          base_path_param_keys.each do |base_path_param|
            unless params.include?(base_path_param.to_sym)
              raise ArgumentError, "Expected #{base_path_param.inspect} to have a value"
            end
          end
          base_path_definition.split("/").map do |segment|
            if param_key = segment_param_key(segment)
              params[param_key]
            else
              segment
            end
          end.join("/")
        end
      end

      protected

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
        handlers = recorded_http_handlers
        resource_class = self
        Module.new do
          (class << self; self; end).class_eval do
            define_method(:registered) do |app|
              handlers.each do |handler|
                verb, relative_path, opts, block = handler
                full_path = "#{resource_class.base_path_definition}/#{relative_path}".
                  gsub("//", "/").gsub(%r{^.+/$}) do |match|
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
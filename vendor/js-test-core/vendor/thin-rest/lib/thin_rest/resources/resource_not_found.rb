module ThinRest
  module Resources
    class ResourceNotFound < Resource
      class << self
        def default_handler(env, name)
          new(env)
        end
      end

      property :name
      def get
        connection.send_head(404)
        connection.send_body(Representations::ResourceNotFound.new(:path_info => connection.rack_request.path_info).to_s) do
          raise RoutingError, "Invalid route: #{connection.rack_request.path_info} ; name: #{name}"
        end
      end
    end
  end
end
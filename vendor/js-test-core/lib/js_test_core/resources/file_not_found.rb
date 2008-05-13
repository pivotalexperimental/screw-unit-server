module JsTestCore
  module Resources
    class FileNotFound
      attr_reader :name
      def initialize(name)
        @name = name
      end

      def get(request, response)
        response.status = 404
        response.body = "Path #{name} not found. You may want to try the /#{WebRoot.dispatch_strategy} directory."
      end
    end
  end
end
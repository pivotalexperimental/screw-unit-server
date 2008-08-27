module JsTestCore
  module Resources
    class FileNotFound < ThinRest::Resource
      property :name
      def get
        connection.send_head(404)
        connection.send_body("Path #{rack_request.path_info} not found. You may want to try the /#{WebRoot.dispatch_strategy} directory.")
      end
    end
  end
end
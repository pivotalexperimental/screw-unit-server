module JsTestCore
  module Resources
    class FileNotFound < ThinRest::Resource
      property :name
      def get
        connection.send_head(404)
        connection.send_body("")
      end
    end
  end
end
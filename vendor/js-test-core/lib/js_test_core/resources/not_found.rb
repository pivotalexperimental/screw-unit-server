module JsTestCore
  module Resources
    class NotFound < Resource
      map "*"

      get "/" do
        call
      end

      put "/" do
        call
      end

      post "/" do
        call
      end

      delete "/" do
        call
      end

      def call
        body = Representations::NotFound.new(:message => "File #{request.path_info} not found").to_s
        [
          404,
          {
            "Content-Type" => "text/html",
            "Content-Length" => body.size.to_s
          },
          body
        ]
      end
    end
  end
end
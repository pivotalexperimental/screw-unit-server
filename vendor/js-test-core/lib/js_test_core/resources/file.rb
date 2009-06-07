module JsTestCore
  module Resources
    class File < Resource
      map "*"

      MIME_TYPES = {
        '.html' => 'text/html',
        '.htm' => 'text/html',
        '.js' => 'text/javascript',
        '.css' => 'text/css',
        '.png' => 'image/png',
        '.jpg' => 'image/jpeg',
        '.jpeg' => 'image/jpeg',
        '.gif' => 'image/gif',
        }

      get "*" do
        do_get
      end
      
      def relative_path
        @relative_path ||= request.path_info
      end

      def absolute_path
        @absolute_path ||= ::File.expand_path("#{public_path}#{relative_path}")
      end

      protected

      def do_get
        if ::File.exists?(absolute_path)
          render_file
        else
          not_found
        end
      end

      def render_file
        extension = ::File.extname(absolute_path)
        content_type = MIME_TYPES[extension] || 'text/html'
        [
          200,
          {
            'Content-Type' => content_type,
            'Last-Modified' => ::File.mtime(absolute_path).rfc822,
            'Content-Length' => ::File.size(absolute_path)
          },
          ::File.read(absolute_path)
        ]
      end

      def not_found
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

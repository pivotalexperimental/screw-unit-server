module JsTestCore
  module Resources
    class File
      MIME_TYPES = {
        '.js' => 'text/javascript',
        '.css' => 'text/css',
        '.png' => 'image/png',
        '.jpg' => 'image/jpeg',
        '.jpeg' => 'image/jpeg',
        '.gif' => 'image/gif',
      }

      attr_reader :absolute_path, :relative_path

      def initialize(absolute_path, relative_path)
        @absolute_path = absolute_path
        @relative_path = relative_path
      end

      def get(request, response)
        extension = ::File.extname(absolute_path)
        response.headers['Content-Type'] = MIME_TYPES[extension] || 'text/html'
        response.body = ::File.read(absolute_path)
      end

      def ==(other)
        return false unless other.class == self.class
        absolute_path == other.absolute_path && relative_path == other.relative_path
      end
    end
  end
end
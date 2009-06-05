module ThinRest
  module Representations
    class ResourceNotFound < Page
      needs :path_info
      protected
      def body_content
        h1 message
      end

      def title_text
        message
      end

      def message
        "File #{path_info} not found"
      end
    end
  end
end

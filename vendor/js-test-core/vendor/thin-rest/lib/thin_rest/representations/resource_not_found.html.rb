module ThinRest
  module Representations
    class ResourceNotFound < Page
      protected
      def body_content
        h1 message
      end

      def title_text
        message
      end

      def message
        "File #{path} not found"
      end
    end
  end
end

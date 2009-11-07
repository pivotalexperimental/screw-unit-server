module JsTestCore
  module Representations
    class NotFound < Page
      attr_reader :message
      needs :message
      protected
      def body_content
        h1 message
      end

      def title_text
        message
      end
    end
  end
end

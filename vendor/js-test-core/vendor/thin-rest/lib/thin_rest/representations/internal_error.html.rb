module ThinRest
  module Representations
    class InternalError < Page
      needs :error
      protected
      def body_content
        h1 error.message
        ul do
          error.backtrace.each do |line|
            li line
          end
        end
      end

      def title_text
        error.message
      end
    end
  end
end

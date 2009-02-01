module ThinRest
  module Representations
    class InternalError < Page
      protected
      def body_content
        h1 error.message
        ul do
          error.backtrace.split("\n").each do |line|
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

module JsTestCore
  module Representations
    class Spec < Page
      needs :spec_files
      protected
      def title_text
        "Js Test Core Suite"
      end

      def head_content
        spec_script_elements
      end

      def spec_script_elements
        spec_files.each do |file|
          script :type => "text/javascript", :src => file
        end
      end
      
      def body_content
      end
    end
  end
end
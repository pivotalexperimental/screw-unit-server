module JsTestCore
  module Representations
    class Spec < Page
      protected
      def title_text
        "Js Test Core Suite"
      end

      def head_content
        spec_script_elements
      end

      def spec_script_elements
        spec_files.each do |file|
          script :type => "text/javascript", :src => file.relative_path
        end
      end
    end
  end
end
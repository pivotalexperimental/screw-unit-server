module JsTestCore
  module Representations
    class Spec < Page
      needs :spec_files, :session_id
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
        script_to_set_window_session_id
      end

      def script_to_set_window_session_id
        script "window._session_id = '#{session_id}';", :type => "text/javascript"
      end
      
      def body_content
      end
    end
  end
end
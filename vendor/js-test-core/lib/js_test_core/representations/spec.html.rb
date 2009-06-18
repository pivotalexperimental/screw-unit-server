module JsTestCore
  module Representations
    class Spec < Page
      class << self
        def project_js_files
          @project_js_files ||= []
        end
        attr_writer :project_js_files

        def project_css_files
          @project_css_files ||= []
        end
        attr_writer :project_css_files
      end

      needs :spec_files, :session_id
      protected
      def title_text
        "Js Test Core Suite"
      end

      def head_content
        project_js_files
        project_css_files
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

      def project_js_files
        self.class.project_js_files.each do |file|
          script :src => file, :type => "text/javascript"
        end
      end

      def project_css_files
        self.class.project_css_files.each do |file|
          link :href => file, :type => "text/css", :media => "screen", :rel => "stylesheet"
        end
      end
      
      def body_content
      end
    end
  end
end
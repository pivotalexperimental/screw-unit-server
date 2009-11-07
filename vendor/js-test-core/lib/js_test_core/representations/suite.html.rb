module JsTestCore
  module Representations
    class Suite < Page
      class << self
        def project_js_files
          @@project_js_files ||= []
        end

        def project_js_files=(files)
          @@project_js_files = files
        end

        def project_css_files
          @@project_css_files ||= []
        end

        def project_css_files=(files)
          @@project_css_files = files
        end
      end

      attr_reader :spec_files
      needs :spec_files
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
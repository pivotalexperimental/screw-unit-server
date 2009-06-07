module JsTestCore
  module Representations
    class Dir < Page
      needs :relative_path, :absolute_path
      protected
      def body_content
        ul do
          ::Dir.glob("#{absolute_path}/*").inject("") do |html, file|
            file_basename = ::File.basename(file)
            li do
              a(file_basename, :href => file_basename)
            end
          end
        end
      end

      def title_text
        "Contents of #{relative_path}"
      end
    end
  end
end

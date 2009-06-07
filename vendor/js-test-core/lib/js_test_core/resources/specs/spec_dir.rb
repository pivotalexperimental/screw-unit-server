module JsTestCore
  module Resources
    module Specs
      class SpecDir < ::JsTestCore::Resources::Dir
        map "/specs"
        include Spec

        get "*" do
          do_get
        end

        protected

        def do_get
          if ::File.directory?(absolute_path)
            get_generated_spec
          else
            pass
          end
        end

        def get_generated_spec
          html = render_spec
          [
            200,
            {
              'Content-Type' => "text/html",
              'Last-Modified' => ::File.mtime(absolute_path).rfc822,
              'Content-Length' => html.length
            },
            html
          ]
        end

        def spec_files
          ::Dir["#{absolute_path}/**/*_spec.js"].map do |file|
            ["#{relative_path}#{file.gsub(absolute_path, "")}"]
          end
        end
      end
    end
  end
end
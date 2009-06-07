module JsTestCore
  module Resources
    module Specs
      class SpecFile < ::JsTestCore::Resources::File
        map "/specs"
        include Spec

        get "*" do
          do_get
        end

        protected

        def do_get
          if ::File.exists?(absolute_path)
            super
          else
            get_generated_spec
          end
        end

        def get_generated_spec
          html = render_spec
          [
            200,
            {
              'Content-Type' => "text/html",
              'Last-Modified' => ::File.mtime("#{absolute_path}.js").rfc822,
              'Content-Length' => html.length
            },
            html
          ]
        end

        def spec_files
          ["#{relative_path}.js"]
        end
      end
    end
  end
end
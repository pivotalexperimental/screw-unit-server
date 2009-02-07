module JsTestCore
  module Resources
    module Specs
      module Spec
        class << self
          def spec_resource_class
            @spec_resource_class ||= JsTestCore::Representations::Spec
          end
          attr_writer :spec_resource_class
        end

        def get_generated_spec
          connection.terminate_after_sending do
            connection.send_head(
              200,
              'Content-Type' => "text/html",
              'Last-Modified' => ::File.mtime(absolute_path).rfc822,
              'Content-Length' => ::File.size(absolute_path)
            )

            connection.send_data(render_spec)
          end
        end

        def render_spec
          spec_resource_class.new(self, :spec_files => spec_files).to_s
        end
      end
    end
  end
end
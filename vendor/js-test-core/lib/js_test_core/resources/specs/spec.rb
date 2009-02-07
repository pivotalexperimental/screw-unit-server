module JsTestCore
  module Resources
    module Specs
      module Spec
        class << self
          def spec_representation_class
            @spec_representation_class ||= JsTestCore::Representations::Spec
          end
          attr_writer :spec_representation_class
        end

        def get_generated_spec
          connection.terminate_after_sending do
            connection.send_head(
              200,
              'Content-Type' => "text/html",
              'Last-Modified' => ::File.mtime(absolute_path).rfc822
            )

            body = render_spec
            connection.send_data("Content-Length: #{body.length}\r\n\r\n")
            connection.send_data(body)
          end
        end

        def render_spec
          Spec.spec_representation_class.new(self, :spec_files => spec_files).to_s
        end
      end
    end
  end
end
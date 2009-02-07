module JsTestCore
  module Resources
    module Specs
      module Spec
        def get_generated_spec
          connection.terminate_after_sending do
            connection.send_head(
              200,
              'Content-Type' => "text/html",
              'Last-Modified' => ::File.mtime(absolute_path).rfc822,
              'Content-Length' => ::File.size(absolute_path)
            )

            connection.send_data(
              JsTestCore::Representations::Spec.new(self, :spec_files => spec_files).to_s
            )
          end
        end
      end
    end
  end
end
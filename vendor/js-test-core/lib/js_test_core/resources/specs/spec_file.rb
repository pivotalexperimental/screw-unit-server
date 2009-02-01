module JsTestCore
  module Resources
    module Specs
      class SpecFileSuperclass < ::JsTestCore::Resources::File
        def get
          if ::File.exists?(absolute_path) && ::File.extname(absolute_path) != ".js"
            super
          else
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

      class SpecFile < SpecFileSuperclass
        def spec_files
          [self]
        end
      end
    end
  end
end
module JsTestCore
  module Resources
    module Specs
      class SpecFile < ::JsTestCore::Resources::File
        include Spec

        def get
          if ::File.exists?(absolute_path) && ::File.extname(absolute_path) != ".js"
            super
          else
            get_generated_spec
          end
        end

        def spec_files
          [self]
        end
      end
    end
  end
end
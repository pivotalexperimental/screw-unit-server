module JsTestCore
  module Resources
    module Specs
      class SpecFileSuperclass < ::JsTestCore::Resources::File
        def get
          if ::File.exists?(absolute_path) && ::File.extname(absolute_path) != ".js"
            super
          else
            get_js
          end
        end

        protected
        def get_js
          raise NotImplementedError, "#{self.class}#get_js needs to be implemented"
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
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

        def render_spec
          Spec.spec_representation_class.new(:spec_files => spec_files).to_s
        end

        protected

        def absolute_path
          @absolute_path ||= ::File.expand_path("#{spec_root_path}#{relative_path.gsub(%r{^/specs}, "")}")
        end
      end
    end
  end
end
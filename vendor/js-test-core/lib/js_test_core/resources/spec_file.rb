module JsTestCore
  module Resources
    class SpecFile < ::JsTestCore::Resources::File
      class << self
        def spec_representation_class
          @spec_representation_class ||= JsTestCore::Representations::Spec
        end

        attr_writer :spec_representation_class
      end

      map "/specs"

      get "/?" do
        do_get
      end

      get "*" do
        do_get
      end

      protected

      def do_get
        if ::File.exists?(absolute_path)
          if ::File.directory?(absolute_path)
            spec_files = ::Dir["#{absolute_path}/**/*_spec.js"].map do |file|
              ["#{relative_path}#{file.gsub(absolute_path, "")}"]
            end
            get_generated_spec(absolute_path, spec_files)
          else
            super
          end
        else
          get_generated_spec("#{absolute_path}.js", ["#{relative_path}.js"])
        end
      end

      def get_generated_spec(real_path, spec_files)
        html = render_spec(spec_files)
        [
          200,
          {
            'Content-Type' => "text/html",
            'Last-Modified' => ::File.mtime(real_path).rfc822,
            'Content-Length' => html.length
          },
          html
        ]
      end

      def render_spec(spec_files)
        self.class.spec_representation_class.new(:spec_files => spec_files).to_s
      end

      def absolute_path
        @absolute_path ||= ::File.expand_path("#{spec_root_path}#{relative_path.gsub(%r{^/specs}, "")}")
      end
    end
  end
end
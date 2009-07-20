module JsTestCore
  module Resources
    class CoreFile < File
      map "/core"

      get "/?" do
        do_get
      end

      get "*" do
        do_get
      end

      def absolute_path
        @absolute_path ||= ::File.expand_path("#{framework_path}#{relative_path.gsub(%r{^/core}, "")}")
      end
    end
  end
end

module JsTestCore
  module Resources
    class Resource < LuckyLuciano::Resource
      protected
      
      def spec_root_path; server.spec_root_path; end
      def implementation_root_path; server.implementation_root_path; end
      def public_path; server.public_path; end
      def core_path; server.core_path; end
      def root_url; server.root_url; end

      def server
        JsTestCore::Configuration
      end
    end
  end
end
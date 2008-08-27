module Thin
  class JsTestCoreConnection < ThinRest::Connection
    protected
    def root_resource
      ::JsTestCore::Resources::WebRoot.new(:connection => self, :public_path => ::JsTestCore::Server.public_path)
    end
  end
end
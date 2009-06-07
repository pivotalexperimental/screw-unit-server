module JsTestCore
  class App < Sinatra::Base
    register(JsTestCore::Resources::WebRoot.route_handler)
    register(JsTestCore::Resources::Runner.route_handler)
    register(JsTestCore::Resources::Session.route_handler)
    register(JsTestCore::Resources::SessionFinish.route_handler)
    register(JsTestCore::Resources::Specs::SpecDir.route_handler)
    register(JsTestCore::Resources::Specs::SpecFile.route_handler)
    register(JsTestCore::Resources::Dir.route_handler)
    register(JsTestCore::Resources::File.route_handler)
  end
end
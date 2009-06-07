module JsTestCore
  class App < Sinatra::Base
    set :logging, true
    register(JsTestCore::Resources::WebRoot.route_handler)
    register(JsTestCore::Resources::Runner.route_handler)
    register(JsTestCore::Resources::Session.route_handler)
    register(JsTestCore::Resources::SessionFinish.route_handler)
    register(JsTestCore::Resources::CoreFile.route_handler)
    register(JsTestCore::Resources::SpecFile.route_handler)
    register(JsTestCore::Resources::File.route_handler)
    register(JsTestCore::Resources::NotFound.route_handler)
  end
end
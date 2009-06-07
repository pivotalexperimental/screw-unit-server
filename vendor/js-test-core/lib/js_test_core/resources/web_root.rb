module JsTestCore
  module Resources
    class WebRoot < Resources::Resource
      map "/"
      class << self
        attr_accessor :dispatch_strategy
        def dispatch_specs
          self.dispatch_strategy = :specs
        end
      end

      get("") do
        "<html><head></head><body>Welcome to the Js Test Server. Click the following link to run you <a href=/specs>spec suite</a>.</body></html>"
      end
    end
  end
end
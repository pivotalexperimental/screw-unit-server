module JsTestCore
  module Resources
    class WebRoot < Resources::Resource
      map "/"
      
      get("") do
        "<html><head></head><body>Welcome to the Js Test Server. Click the following link to run you <a href=/specs>spec suite</a>.</body></html>"
      end
    end
  end
end
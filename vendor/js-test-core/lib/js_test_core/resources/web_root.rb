module JsTestCore
  module Resources
    class WebRoot < Resource
      map "/"
      
      get("") do
        puts "#{__FILE__}:#{__LINE__}"
        [200, {}, "<html><head></head><body>Welcome to the Js Test Server. Click the following link to run you <a href=/specs>spec suite</a>.</body></html>"]
      end
    end
  end
end
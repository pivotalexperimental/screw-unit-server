module JsTestCore
  module Resources
    class ImplementationsDeprecation < Resource
      map "/implementations"

      get "*" do
        new_path = File.path("javascripts", *params["splat"])
        [301, {'Location' => new_path}, "This page has been moved to #{new_path}"]
      end
    end
  end
end
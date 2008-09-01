module JsTestCore
  module Resources
    class Runners
      class IExploreRunner < Runner
        protected
        def selenium_browser_start_command
          "*iexplore"
        end
      end
    end
  end
end

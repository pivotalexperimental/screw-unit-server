module JsTestCore
  module Resources
    class Runners
      class FirefoxRunner < Runner
        protected
        def selenium_browser_start_command
          "*firefox"
        end
      end
    end
  end
end

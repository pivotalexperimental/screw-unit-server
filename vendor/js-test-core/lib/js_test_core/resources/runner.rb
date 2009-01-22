module JsTestCore
  module Resources
    class Runner < ThinRest::Resource
      class Collection < ThinRest::Resource
        property :selenium_browser_start_command
        route 'firefox' do |env, name|
          self.selenium_browser_start_command = "*firefox"
          self
        end
        route 'iexplore' do |env, name|
          self.selenium_browser_start_command = "*iexplore"
          self
        end

        def after_initialize
          super
          self.selenium_browser_start_command = rack_request['selenium_browser_start_command']
        end

        def post
          spec_url = rack_request['spec_url'].to_s == "" ? full_spec_suite_url : rack_request['spec_url']
          parsed_spec_url = URI.parse(spec_url)
          selenium_host = rack_request['selenium_host'].to_s == "" ? 'localhost' : rack_request['selenium_host'].to_s
          selenium_port = rack_request['selenium_port'].to_s == "" ? 4444 : Integer(rack_request['selenium_port'])
          http_address = "#{parsed_spec_url.scheme}://#{parsed_spec_url.host}:#{parsed_spec_url.port}"
          driver = Selenium::SeleniumDriver.new(
            selenium_host,
            selenium_port,
            selenium_browser_start_command,
            http_address
          )
          begin
            driver.start
          rescue Errno::ECONNREFUSED => e
            raise Errno::ECONNREFUSED, "Cannot connect to Selenium Server at #{http_address}. To start the selenium server, run `selenium`."
          end
          runner = Runner.new(:driver => driver)
          Runner.register(runner)
          Thread.start do
            driver.open("/")
            driver.create_cookie("session_id=#{runner.session_id}")
            driver.open(parsed_spec_url.path)
          end
          connection.send_head
          connection.send_body("session_id=#{runner.session_id}")
        end

        protected
        def full_spec_suite_url
          "#{Server.root_url}/specs"
        end
      end

      class << self
        def find(id)
          instances[id.to_s]
        end

        def finalize(session_id, text)
          if runner = find(session_id)
            runner.finalize(text)
          end
        end

        def register(runner)
          instances[runner.session_id] = runner
        end

        protected
        def instances
          @instances ||= {}
        end
      end

      include FileUtils
      property :driver
      attr_reader :profile_dir, :session_run_result

      def after_initialize
        profile_base = "#{::Dir.tmpdir}/js_test_core/#{self.class.name}"
        mkdir_p profile_base
        @profile_dir = "#{profile_base}/#{Time.now.to_i}"
      end

      def finalize(session_run_result)
        driver.stop
        @session_run_result = session_run_result.to_s
      end

      def running?
        driver.session_started?
      end

      def successful?
        !running? && session_run_result.empty?
      end

      def failed?
        !running? && !successful?
      end

      def session_id
        driver.session_id
      end
    end
  end
end

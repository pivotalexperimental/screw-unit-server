module JsTestCore
  module Resources
    class Runner < Resource
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

      map "/runners"
      include FileUtils
      attr_reader :driver, :session_run_result

      post "/" do
        do_post params["selenium_browser_start_command"]
      end

      post "/firefox" do
        do_post "*firefox"
      end

      post '/iexplore' do |env, name|
        do_post "*iexplore"
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

      protected
      def do_post(selenium_browser_start_command)
        spec_url = request['spec_url'].to_s == "" ? full_spec_suite_url : request['spec_url']
        parsed_spec_url = URI.parse(spec_url)
        selenium_host = request['selenium_host'].to_s == "" ? 'localhost' : request['selenium_host'].to_s
        selenium_port = request['selenium_port'].to_s == "" ? 4444 : Integer(request['selenium_port'])
        http_address = "#{parsed_spec_url.scheme}://#{parsed_spec_url.host}:#{parsed_spec_url.port}"
        @driver = Selenium::Client::Driver.new(
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
        Runner.register(self)
        Thread.start do
          driver.open("/")
          driver.create_cookie("session_id=#{session_id}")
          driver.open(parsed_spec_url.path)
        end
        body = "session_id=#{session_id}"
        [
          200,
          {
            "Content-Length" => body.length  
          },
          body
        ]
      end

      def full_spec_suite_url
        "#{Configuration.root_url}/specs"
      end
    end
  end
end

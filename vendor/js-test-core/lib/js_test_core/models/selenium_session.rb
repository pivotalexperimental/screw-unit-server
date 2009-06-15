module JsTestCore
  module Models
    class SeleniumSession
      class << self
        def find(id)
          instances[id.to_s]
        end

        def register(selenium_session)
          instances[selenium_session.session_id] = selenium_session
        end

        protected
        def instances
          @instances ||= {}
        end
      end
      
      attr_reader :spec_url, :selenium_browser_start_command, :selenium_host, :selenium_port, :http_address, :driver, :run_result

      def initialize(params={})
        @spec_url = params[:spec_url]
        @selenium_browser_start_command = params[:selenium_browser_start_command]
        @selenium_host = params[:selenium_host]
        @selenium_port = params[:selenium_port]

        memoized_parsed_spec_url = parsed_spec_url
        @http_address = "#{memoized_parsed_spec_url.scheme}://#{memoized_parsed_spec_url.host}:#{memoized_parsed_spec_url.port}"

        @driver = Selenium::Client::Driver.new(
          selenium_host,
          selenium_port,
          selenium_browser_start_command,
          http_address
        )
      end

      def start
        begin
          driver.start
        rescue Errno::ECONNREFUSED => e
          raise Errno::ECONNREFUSED, "Cannot connect to Selenium Server at #{http_address}. To start the selenium server, run `selenium`."
        end
        self.class.register(self)
        Thread.start do
          driver.open("/")
          driver.create_cookie("session_id=#{session_id}")
          driver.open("#{parsed_spec_url.path}")
        end
      end

      def session_id
        driver.session_id
      end

      def finish(run_result)
        driver.stop
        @run_result = run_result.to_s
      end

      def running?
        driver.session_started?
      end

      def successful?
        !running? && run_result.empty?
      end

      def failed?
        !running? && !successful?
      end

      protected

      def parsed_spec_url
        URI.parse(spec_url)
      end
    end
  end
end
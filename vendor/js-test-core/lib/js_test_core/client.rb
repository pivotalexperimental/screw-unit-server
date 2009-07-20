module JsTestCore
  class Client
    RUNNING_RUNNER_STATE = "running"
    PASSED_RUNNER_STATE = "success"
    FAILED_RUNNER_STATE = "failed"
    FINISHED_RUNNER_STATES = [PASSED_RUNNER_STATE, FAILED_RUNNER_STATE]

    DEFAULT_SELENIUM_BROWSER = "*firefox"
    DEFAULT_SELENIUM_HOST = "0.0.0.0"
    DEFAULT_SELENIUM_PORT = 4444
    DEFAULT_SPEC_URL = "http://localhost:8080/specs"
    DEFAULT_TIMEOUT = 60

    class ClientException < Exception
    end

    class InvalidStatusResponse < ClientException
    end

    class << self
      def run(parameters={})
        new(parameters).run
      end

      def run_argv(argv)
        opts = Trollop.options(argv) do
          opt(
            :selenium_browser,
            "The Selenium browser (e.g. *firefox). See http://selenium-rc.openqa.org/",
            :type => String,
            :default => DEFAULT_SELENIUM_BROWSER
          )
          opt(
            :selenium_host,
            "The host name of the Selenium Server relative to where this file is executed",
            :type => String,
            :default => DEFAULT_SELENIUM_HOST
          )
          opt(
            :selenium_port,
            "The port of the Selenium Server relative to where this file is executed",
            :type => Integer,
            :default => DEFAULT_SELENIUM_PORT
          )
          opt(
            :spec_url,
            "The url of the js spec server, relative to the browsers running via the Selenium Server",
            :type => String,
            :default => DEFAULT_SPEC_URL
          )
          opt(
            :timeout,
            "The timeout limit of the test run",
            :type => Integer,
            :default => DEFAULT_TIMEOUT
          )
        end
        run opts
      end
    end

    attr_reader :parameters, :selenium_client, :current_status, :flushed_console
    def initialize(parameters)
      @parameters = parameters
      @flushed_console = ""
    end

    def run
      if parameters[:timeout]
         Timeout.timeout(parameters[:timeout]) {do_run}
      else
        do_run
      end
    end

    protected
    def do_run
      start_selenium_client
      wait_for_session_to_finish
      flush_console
      suite_passed?
    end

    def start_selenium_client
      uri =  URI.parse(parameters[:spec_url] || DEFAULT_SPEC_URL)
      @selenium_client = Selenium::Client::Driver.new(
        :host => parameters[:selenium_host] || DEFAULT_SELENIUM_HOST,
        :port => parameters[:selenium_port] || DEFAULT_SELENIUM_PORT,
        :browser => parameters[:selenium_browser] || DEFAULT_SELENIUM_BROWSER,
        :url => "#{uri.scheme}://#{uri.host}:#{uri.port}"
      )
      selenium_client.start
      selenium_client.open([uri.path, uri.query].compact.join("?"))
    end

    def wait_for_session_to_finish
      while !suite_finished?
        poll
        flush_console
        sleep 0.25
      end
    end

    def poll
      raw_status = selenium_client.get_eval("window.JsTestServer.status()")
      unless raw_status.to_s == ""
        @current_status = JSON.parse(raw_status)
      end
    end

    def suite_finished?
      current_status && FINISHED_RUNNER_STATES.include?(runner_state)
    end

    def flush_console
      if current_status
        STDOUT.print console.gsub(flushed_console)
        @flushed_console = console
      end
    end

    def suite_passed?
      runner_state == PASSED_RUNNER_STATE
    end

    def runner_state
      current_status["runner_state"]
    end

    def console
      current_status["console"]
    end
  end
end

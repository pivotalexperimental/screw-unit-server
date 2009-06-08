module JsTestCore
  class Client
    class ClientException < Exception
    end

    class InvalidStatusResponse < ClientException
    end

    class SessionNotFound < ClientException
    end

    class << self
      def run(parameters={})
        new(parameters).run
      end

      def run_argv(argv)
        params = {}
        parser = OptionParser.new do |o|
          o.banner = "JsTestCore Runner"
          o.banner << "\nUsage: #{$0} [options] [-- untouched arguments]"

          o.on
          o.on('-s', '--selenium_browser_start_command=selenium_browser_start_command', "The Selenium server command to start the browser. See http://selenium-rc.openqa.org/") do |selenium_browser_start_command|
            params[:selenium_browser_start_command] = selenium_browser_start_command
          end

          o.on('-h', '--selenium_host=SELENIUM_HOST', "The host name of the Selenium Server relative to where this file is executed") do |host|
            params[:selenium_host] = host
          end

          o.on('-p', '--selenium_port=SELENIUM_PORT', "The port of the Selenium Server relative to where this file is executed") do |port|
            params[:selenium_port] = port
          end

          o.on('-u', '--spec_url=SPEC_URL', "The url of the js spec server, relative to the browsers running via the Selenium Server") do |spec_url|
            params[:spec_url] = spec_url
          end

          o.on('-t', '--timeout=TIMEOUT', "The timeout limit of the test run") do |timeout|
            params[:timeout] = Integer(timeout)
          end

          o.on_tail
        end
        parser.order!(argv)
        run params
      end
    end

    attr_reader :parameters, :query_string, :http, :session_start_response, :last_poll_status, :last_poll_reason, :last_poll
    def initialize(parameters)
      @parameters = parameters
      @query_string = SeleniumServerConfiguration.query_string_from(parameters)
    end

    def run
      if parameters[:timeout]
        Timeout.timeout(parameters[:timeout]) {do_run}
      else
        do_run
      end
    end

    def parts_from_query(query)
      query.split('&').inject({}) do |acc, key_value_pair|
        key, value = key_value_pair.split('=')
        acc[key] = value
        acc
      end
    end
    
    protected
    def do_run
      Net::HTTP.start(DEFAULT_HOST, DEFAULT_PORT) do |@http|
        start_runner
        wait_for_session_to_finish
      end
      report_result
    end

    def start_runner
      @session_start_response = http.post(Resources::SeleniumSession.path, query_string)
    end

    def wait_for_session_to_finish
      while session_not_completed?
        poll
        sleep 0.25
      end
    end

    def report_result
      case last_poll_status
      when Resources::SeleniumSession::SUCCESSFUL_COMPLETION
        STDOUT.puts "SUCCESS"
        true
      when Resources::SeleniumSession::FAILURE_COMPLETION
        STDOUT.puts "FAILURE"
        STDOUT.puts last_poll_reason
        false
      else
        raise InvalidStatusResponse, "Invalid Status: #{last_poll_status}"
      end
    end

    def session_not_completed?
      last_poll_status.nil? || last_poll_status == Resources::SeleniumSession::RUNNING
    end

    def poll
      @last_poll = http.get("/sessions/#{session_id}")
      ensure_session_exists!
      parts = parts_from_query(last_poll.body)
      @last_poll_status = parts['status']
      @last_poll_reason = parts['reason']
    end

    def ensure_session_exists!
      if (400..499).include?(Integer(last_poll.code))
        raise SessionNotFound, "Could not find session with id #{session_id}"
      end
    end

    def session_id
      @session_id ||= parts_from_query(session_start_response.body)['session_id']
    end
  end
end
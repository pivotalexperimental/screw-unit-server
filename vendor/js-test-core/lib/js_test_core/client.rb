module JsTestCore
  class Client
    class ClientException < Exception
    end

    class InvalidStatusResponse < ClientException
    end

    class SuiteNotFound < ClientException
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
          o.on('-h', '--selenium_host=SELENIUM_HOST', "The host name of the Selenium Server relative to where this file is executed") do |host|
            params[:selenium_host] = host
          end

          o.on('-p', '--selenium_port=SELENIUM_PORT', "The port of the Selenium Server relative to where this file is executed") do |port|
            params[:selenium_port] = port
          end

          o.on('-u', '--spec_url=SPEC_URL', "The url of the js spec server, relative to the browsers running via the Selenium Server") do |spec_url|
            params[:spec_url] = spec_url
          end

          o.on_tail
        end
        parser.order!(argv)
        run params
      end
    end

    attr_reader :parameters, :query_string, :http, :suite_start_response, :last_poll_result, :last_poll
    def initialize(parameters)
      @parameters = parameters
      @query_string = SeleniumServerConfiguration.query_string_from(parameters)
    end

    def run
      Net::HTTP.start(DEFAULT_HOST, DEFAULT_PORT) do |@http|
        start_firefox_runner
        wait_for_suite_to_finish
      end
      report_result
    end

    def parts_from_query(query)
      query.split('&').inject({}) do |acc, key_value_pair|
        key, value = key_value_pair.split('=')
        acc[key] = value
        acc
      end
    end
    
    protected
    def start_firefox_runner
      @suite_start_response = http.post('/runners/firefox', query_string)
    end

    def wait_for_suite_to_finish
      poll while suite_not_completed?
    end

    def report_result
      case last_poll_result
      when Resources::Suite::SUCCESSFUL_COMPLETION
        STDOUT.puts "SUCCESS"
        true
      when Resources::Suite::FAILURE_COMPLETION
        STDOUT.puts "FAILURE"
        false
      else
        raise InvalidStatusResponse, "Invalid Status: #{last_poll_result}"
      end
    end

    def suite_not_completed?
      last_poll_result.nil? || last_poll_result == Resources::Suite::RUNNING
    end

    def poll
      @last_poll = http.get("/suites/#{suite_id}")
      ensure_suite_exists!
      @last_poll_result = parts_from_query(last_poll.body)['status']
    end

    def ensure_suite_exists!
      if (400..499).include?(Integer(last_poll.code))
        raise SuiteNotFound, "Could not find suite with id #{suite_id}"
      end
    end

    def suite_id
      @suite_id ||= parts_from_query(suite_start_response.body)['suite_id']
    end
  end
end
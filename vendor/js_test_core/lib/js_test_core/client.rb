module JsTestCore
  class Client
    class << self
      def run(params={})
        data = []
        data << "selenium_host=#{CGI.escape(params[:selenium_host] || 'localhost')}"
        data << "selenium_port=#{CGI.escape((params[:selenium_port] || 4444).to_s)}"
        data << "spec_url=#{CGI.escape(params[:spec_url])}" if params[:spec_url]
        response = Net::HTTP.start(DEFAULT_HOST, DEFAULT_PORT) do |http|
          http.post('/runners/firefox', data.join("&"))
        end

        body = response.body
        if body.empty?
          puts "SUCCESS"
          return true
        else
          puts "FAILURE"
          puts body
          return false
        end
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
  end
end
require File.expand_path("#{File.dirname(__FILE__)}/../unit_spec_helper")

module JsTestCore
  describe SeleniumServerConfiguration do
    describe '#query_string' do
      context "when not passed explicit options" do
        it "defaults selenium_browser_start_command to '*firefox' and selenium_host to 'localhost' and selenium_port to 4444 and ignores spec_url" do
          configuration = SeleniumServerConfiguration.new
          configuration.query_string.should include("selenium_browser_start_command=#{CGI.escape("*firefox")}")
          configuration.query_string.should include("selenium_host=localhost")
          configuration.query_string.should include("selenium_port=4444")
          configuration.query_string.should_not include("spec_url")
        end
      end

      context "when passed explicit options" do
        attr_reader :configuration, :selenium_browser_start_command, :selenium_host, :selenium_port, :spec_url
        before do
          @selenium_browser_start_command = "*iexplore"
          @selenium_host = "google.com"
          @selenium_port = "4332"
          @spec_url = "http://foobar.com/foo"
          @configuration = SeleniumServerConfiguration.new(
            :selenium_browser_start_command => selenium_browser_start_command,
            :selenium_host => selenium_host,
            :selenium_port => selenium_port,
            :spec_url => spec_url
          )
        end

        it "sets the selenium_browser_start_command option" do
          configuration.query_string.should include("selenium_browser_start_command=#{CGI.escape(selenium_browser_start_command)}")
        end

        it "sets the selenium_host option" do
          configuration.query_string.should include("selenium_host=#{selenium_host}")
        end

        it "sets the selenium_port option" do
          configuration.query_string.should include("selenium_port=#{selenium_port}")
        end

        it "sets the spec_url option" do
          configuration.query_string.should include("spec_url=#{spec_url}")
        end
      end
    end
  end
end

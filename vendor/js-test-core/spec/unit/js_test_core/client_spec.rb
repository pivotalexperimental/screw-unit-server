require File.expand_path("#{File.dirname(__FILE__)}/../unit_spec_helper")

module JsTestCore
  describe Client do
    describe '.run' do
      attr_reader :stdout, :request
      before do
        @stdout = StringIO.new
        Client.const_set(:STDOUT, stdout)
        stub.instance_of(Client).sleep
      end

      after do
        Client.__send__(:remove_const, :STDOUT)
      end

      describe "#start" do
        attr_reader :driver, :browser_host, :spec_url, :selenium_browser_start_command, :selenium_host, :selenium_port

        context "with default runner parameters" do
          before do
            @driver = FakeSeleniumDriver.new

            expected_selenium_client_params = {
              :host => "0.0.0.0", :port => 4444, :browser => "*firefox", :url => "http://localhost:8080"
            }

            mock.proxy(Selenium::Client::Driver).new(expected_selenium_client_params) do
              driver
            end
          end

          context "when the suite fails" do
            it "returns false" do
              mock.proxy(driver).start.ordered
              mock.proxy(driver).open("/specs").ordered

              mock.strong(driver).get_eval("window.JsTestServer.status()") do
                {"runner_state" => Client::RUNNING_RUNNER_STATE, "console" => ""}.to_json
              end

              mock.strong(driver).get_eval("window.JsTestServer.status()") do
                {"runner_state" => Client::RUNNING_RUNNER_STATE, "console" => ".."}.to_json
              end

              mock.strong(driver).get_eval("window.JsTestServer.status()") do
                {"runner_state" => Client::RUNNING_RUNNER_STATE, "console" => "...F."}.to_json
              end

              mock.strong(driver).get_eval("window.JsTestServer.status()") do
                {"runner_state" => Client::FAILED_RUNNER_STATE, "console" => "...F..\n\nFailure\n/specs/foo_spec.js"}.to_json
              end

              Client.run.should be_false
            end
          end

          context "when the suite passes" do
            it "returns true" do
              mock.proxy(driver).start.ordered
              mock.proxy(driver).open("/specs").ordered

              mock.strong(driver).get_eval("window.JsTestServer.status()") do
                {"runner_state" => Client::RUNNING_RUNNER_STATE, "console" => ""}.to_json
              end

              mock.strong(driver).get_eval("window.JsTestServer.status()") do
                {"runner_state" => Client::RUNNING_RUNNER_STATE, "console" => ".."}.to_json
              end

              mock.strong(driver).get_eval("window.JsTestServer.status()") do
                {"runner_state" => Client::RUNNING_RUNNER_STATE, "console" => "....."}.to_json
              end

              mock.strong(driver).get_eval("window.JsTestServer.status()") do
                {"runner_state" => Client::PASSED_RUNNER_STATE, "console" => "......\n\nPassed"}.to_json
              end

              Client.run.should be_true
            end
          end
        end

        describe "with overridden runner parameters" do
          it "allows overrides for :host, :port, :browser, and :url" do
            driver = FakeSeleniumDriver.new

            host = "myhost"
            port = 9999
            browser = "*iexplore"
            spec_url = "http://myspechost:7777/specs/path"
            expected_selenium_client_params = {
              :host => host, :port => port, :browser => browser, :url => "http://myspechost:7777"
            }
            mock.proxy(Selenium::Client::Driver).new(expected_selenium_client_params) do
              driver
            end

            mock.proxy(driver).start.ordered
            mock.proxy(driver).open("/specs/path").ordered

            mock.strong(driver).get_eval("window.JsTestServer.status()") do
              {"runner_state" => Client::RUNNING_RUNNER_STATE, "console" => ""}.to_json
            end

            mock.strong(driver).get_eval("window.JsTestServer.status()") do
              {"runner_state" => Client::RUNNING_RUNNER_STATE, "console" => ".."}.to_json
            end

            mock.strong(driver).get_eval("window.JsTestServer.status()") do
              {"runner_state" => Client::RUNNING_RUNNER_STATE, "console" => "....."}.to_json
            end

            mock.strong(driver).get_eval("window.JsTestServer.status()") do
              {"runner_state" => Client::PASSED_RUNNER_STATE, "console" => "......\n\nPassed"}.to_json
            end

            Client.run(:selenium_host => host, :selenium_port => port, :selenium_browser => browser, :spec_url => spec_url).
              should be_true
          end
        end
      end
    end

    describe ".run_argv" do
      attr_reader :request, :response
      before do
        stub(Client).puts
      end

      context "when passed-in Hash contains :selenium_browser" do
        it "passes the spec_url as a post parameter" do
          selenium_browser = '*iexplore'
          mock(Client).run(satisfy do |params|
            default_params.merge(:selenium_browser => selenium_browser).
              to_set.subset?(params.to_set)
          end)
          client = Client.run_argv(['--selenium-browser', selenium_browser])
        end
      end

      context "when passed-in Hash contains :spec_url" do
        it "passes the spec_url as a post parameter" do
          spec_url = 'http://foobar.com/foo'
          mock(Client).run(satisfy do |params|
            default_params.merge(:spec_url => spec_url).
              to_set.subset?(params.to_set)
          end)
          client = Client.run_argv(['--spec-url', spec_url])
        end
      end

      context "when passed-in Hash contains :selenium_host" do
        it "passes the selenium_host as a post parameter" do
          selenium_host = 'test-runner'
          mock(Client).run(satisfy do |params|
            default_params.merge(:selenium_host => selenium_host).
              to_set.subset?(params.to_set)
          end)
          client = Client.run_argv(['--selenium-host', selenium_host])
        end
      end

      context "when passed-in Hash contains :selenium_port" do
        it "passes the selenium_port as a post parameter" do
          selenium_port = 5000
          mock(Client).run(satisfy do |params|
            default_params.merge(:selenium_port => selenium_port).
              to_set.subset?(params.to_set)
          end)
          client = Client.run_argv(['--selenium-port', selenium_port.to_s])
        end
      end

      context "when passed-in Hash contains :timeout" do
        it "passes the timeout as a post parameter" do
          mock(Client).run(satisfy do |params|
            default_params.merge(:timeout => 5).
              to_set.subset?(params.to_set)
          end)
          client = Client.run_argv(['--timeout', "5"])
        end
      end

      def default_params
        {
          :selenium_browser => "*firefox",
          :selenium_host => "0.0.0.0",
          :selenium_port => 4444,
          :spec_url => "http://localhost:8080/specs",
          :timeout => 60
        }
      end
    end
  end
end

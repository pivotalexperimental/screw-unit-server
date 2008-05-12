require File.expand_path("#{File.dirname(__FILE__)}/../unit_spec_helper")

module JsTestCore
  describe Client do
    describe '.run' do
      describe 'when successful' do
        before do
          request = Object.new
          mock(request).post("/runners/firefox", "selenium_host=localhost&selenium_port=4444")
          response = Object.new
          mock(response).body {""}
          mock(Net::HTTP).start(DEFAULT_HOST, DEFAULT_PORT).yields(request) {response}
          stub(Client).puts
        end

        it "returns true" do
          Client.run.should be_true
        end

        it "prints 'SUCCESS'" do
          mock(Client).puts("SUCCESS")
          Client.run
        end
      end

      describe 'when unsuccessful' do
        before do
          request = Object.new
          mock(request).post("/runners/firefox", "selenium_host=localhost&selenium_port=4444")
          response = Object.new
          mock(response).body {"the failure message"}
          mock(Net::HTTP).start(DEFAULT_HOST, DEFAULT_PORT).yields(request) {response}
          stub(Client).puts
        end

        it "returns false" do
          Client.run.should be_false
        end

        it "prints 'FAILURE' and the error message(s)" do
          mock(Client).puts("FAILURE")
          mock(Client).puts("the failure message")
          Client.run
        end
      end

      describe "arguments" do
        attr_reader :request, :response
        before do
          @request = Object.new
          @response = Object.new
          mock(response).body {""}
          mock(Net::HTTP).start(DEFAULT_HOST, DEFAULT_PORT).yields(request) {response}
          stub(Client).puts
        end

        describe "when passed a custom spec_url" do
          it "passes the spec_url as a post parameter" do
            spec_url = 'http://foobar.com/foo'
            mock(request).post(
              "/runners/firefox",
              "selenium_host=localhost&selenium_port=4444&spec_url=#{CGI.escape(spec_url)}"
            )
            Client.run(:spec_url => spec_url)
          end
        end

        describe "when passed a custom selenium host" do
          it "passes the selenium_host as a post parameter" do
            selenium_host = 'test-runner'
            mock(request).post(
              "/runners/firefox",
              "selenium_host=test-runner&selenium_port=4444"
            )
            Client.run(:selenium_host => selenium_host)
          end
        end

        describe "when passed a custom selenium port" do
          it "passes the selenium_port as a post parameter" do
            selenium_port = 5000
            mock(request).post(
              "/runners/firefox",
              "selenium_host=localhost&selenium_port=5000"
            )
            Client.run(:selenium_port => selenium_port)
          end
        end
      end

    end
    
    describe ".run_argv" do
      attr_reader :request, :response
      before do
          @request = Object.new
          @response = Object.new
          mock(response).body {""}
          mock(Net::HTTP).start(DEFAULT_HOST, DEFAULT_PORT).yields(request) {response}
          stub(Client).puts
        end

      describe "when passed a custom spec_url" do
        it "passes the spec_url as a post parameter" do
          spec_url = 'http://foobar.com/foo'
          mock(request).post(
            "/runners/firefox",
            "selenium_host=localhost&selenium_port=4444&spec_url=#{CGI.escape(spec_url)}"
          )
          Client.run_argv(['--spec_url', spec_url])
        end
      end

      describe "when passed a custom selenium host" do
        it "passes the selenium_host as a post parameter" do
          selenium_host = 'test-runner'
          mock(request).post(
            "/runners/firefox",
            "selenium_host=test-runner&selenium_port=4444"
          )
          Client.run_argv(['--selenium_host', selenium_host])
        end
      end

      describe "when passed a custom selenium port" do
        it "passes the selenium_port as a post parameter" do
          selenium_port = 5000
          mock(request).post(
            "/runners/firefox",
            "selenium_host=localhost&selenium_port=5000"
          )
          Client.run_argv(['--selenium_port', selenium_port.to_s])
        end
      end
    end
  end
end

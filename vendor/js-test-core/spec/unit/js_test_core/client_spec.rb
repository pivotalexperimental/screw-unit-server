require File.expand_path("#{File.dirname(__FILE__)}/../unit_spec_helper")

module JsTestCore
  describe Client do
    describe '.run' do
      attr_reader :stdout, :request
      before do
        @stdout = StringIO.new
        Client.const_set(:STDOUT, stdout)
        @request = "http request"
        mock(Net::HTTP).start(DEFAULT_HOST, DEFAULT_PORT).yields(request)
        stub.instance_of(Client).sleep
      end

      after do
        Client.__send__(:remove_const, :STDOUT)
      end

      it "tells the server to start a session run in Firefox and polls the status of the session until the session is complete" do
        mock_post_to_runner("*firefox")
        mock_polling_returns([running_status, running_status, success_status])
        Client.run
      end

      context "when the Session run ends in 'success'" do
        before do
          mock_post_to_runner("*firefox")
          mock_polling_returns([running_status, running_status, success_status])
        end

        it "reports success" do
          Client.run
          stdout.string.strip.should == "SUCCESS"
        end

        it "returns true" do
          Client.run.should be_true
        end
      end

      context "when the Session run ends in 'failure'" do
        attr_reader :failure_reason
        before do
          mock_post_to_runner("*firefox")
          @failure_reason = "I have a failed test"
          mock_polling_returns([running_status, running_status, failure_status(failure_reason)])
        end

        it "reports failure and reason" do
          Client.run
          stdout.string.strip.should include("FAILURE")
          stdout.string.strip.should include(failure_reason)
        end

        it "returns false" do
          Client.run.should be_false
        end

        it "reports the reason for failure"
      end

      context "when the Session is not found" do
        it "raises a SessionNotFound error" do
          mock_post_to_runner("*firefox")
          mock(request).get(Resources::SeleniumSession.path(":session_id", :session_id => "my_session_id")) do
            stub(session_response = Object.new).code {"404"}
            session_response
          end
          lambda {Client.run}.should raise_error(Client::SessionNotFound)
        end
      end

      context "when the Session run ends in with invalid status" do
        it "raises an InvalidStatusResponse" do
          mock_post_to_runner("*firefox")
          mock_polling_returns([running_status, running_status, "status=this is an unexpected status result"])
          lambda {Client.run}.should raise_error(Client::InvalidStatusResponse)
        end
      end

      context "when passed-in a timeout" do
        it "wraps a timeout around the run" do
          mock.proxy(Timeout).timeout(5)
          mock_post_to_runner("*firefox")
          mock_polling_returns([running_status, running_status, success_status])
          Client.run(:timeout => 5)
        end
      end

      context "when not passed-in a timeout" do
        it "does not wrap a timeout around the run" do
          dont_allow(Timeout).timeout
          mock_post_to_runner("*firefox")
          mock_polling_returns([running_status, running_status, success_status])
          Client.run
        end
      end

      def mock_post_to_runner(selenium_browser_start_command)
        mock(start_session_response = Object.new).body {"session_id=my_session_id"}
        mock(request).post(Resources::SeleniumSession.path, "selenium_browser_start_command=#{CGI.escape(selenium_browser_start_command)}&selenium_host=localhost&selenium_port=4444") do
          start_session_response
        end
      end

      def mock_polling_returns(session_statuses=[])
        mock(request).get(Resources::SeleniumSession.path(":session_id", :session_id => "my_session_id")) do
          stub(session_response = Object.new).body {session_statuses.shift}
          stub(session_response).code {"200"}
          session_response
        end.times(session_statuses.length)
      end

      def running_status
        "status=#{Resources::SeleniumSession::RUNNING}"
      end

      def success_status
        "status=#{Resources::SeleniumSession::SUCCESSFUL_COMPLETION}"
      end

      def failure_status(reason)
        "status=#{Resources::SeleniumSession::FAILURE_COMPLETION}&reason=#{reason}"
      end
    end

    describe ".run_argv" do
      attr_reader :request, :response
      before do
        stub(Client).puts
      end

      context "when passed-in Hash contains :selenium_browser_start_command" do
        it "passes the spec_url as a post parameter" do
          selenium_browser_start_command = '*iexplore'
          mock(Client).run(:selenium_browser_start_command => selenium_browser_start_command)
          client = Client.run_argv(['--selenium_browser_start_command', selenium_browser_start_command])
        end
      end

      context "when passed-in Hash contains :spec_url" do
        it "passes the spec_url as a post parameter" do
          spec_url = 'http://foobar.com/foo'
          mock(Client).run(:spec_url => spec_url)
          client = Client.run_argv(['--spec_url', spec_url])
        end
      end

      context "when passed-in Hash contains :selenium_host" do
        it "passes the selenium_host as a post parameter" do
          selenium_host = 'test-runner'
          mock(Client).run(:selenium_host => selenium_host)
          client = Client.run_argv(['--selenium_host', selenium_host])
        end
      end

      context "when passed-in Hash contains :selenium_port" do
        it "passes the selenium_port as a post parameter" do
          selenium_port = "5000"
          mock(Client).run(:selenium_port => selenium_port)
          client = Client.run_argv(['--selenium_port', selenium_port])
        end
      end

      context "when passed-in Hash contains :timeout" do
        it "passes the timeout as a post parameter" do
          mock(Client).run(:timeout => 5)
          client = Client.run_argv(['--timeout', "5"])
        end
      end
    end

    describe '#parts_from_query' do
      attr_reader :client
      before do
        @client = Client.new(params_does_not_matter = {})
      end

      it "parses empty query into an empty hash" do
        client.parts_from_query("").should == {}
      end

      it "parses a single key value pair into a single-element hash" do
        client.parts_from_query("foo=bar").should == {'foo' => 'bar'}
      end

      it "parses a multiple key value pairs into a multi-element hash" do
        client.parts_from_query("foo=bar&baz=quux").should == {'foo' => 'bar', 'baz' => 'quux'}
      end
    end
  end
end

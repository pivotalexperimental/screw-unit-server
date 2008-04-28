require File.expand_path("#{File.dirname(__FILE__)}/../../unit_spec_helper")

module JsTestCore
  module Resources
    describe SuiteFinish do
    attr_reader :stdout, :suite_finish, :suite
    before do
      @stdout = StringIO.new
      SuiteFinish.const_set(:STDOUT, stdout)
      @suite = Suite.new('foobar')
      @suite_finish = SuiteFinish.new(suite)
    end

    after do
      SuiteFinish.__send__(:remove_const, :STDOUT)
    end

    describe ".post" do
      describe "when the request has no session_id" do
        it "writes the body of the request to stdout" do
          body = "The text in the POST body"
          request = Rack::Request.new({'rack.input' => StringIO.new("text=#{body}")})
          request.body.string.should == "text=#{body}"
          response = Rack::Response.new

          suite_finish.post(request, response)
          stdout.string.should == "#{body}\n"
        end
      end

      describe "when the request has a session_id" do
        attr_reader :request, :response, :runner, :session_id, :driver
        before do
          runner_request = Rack::Request.new( Rack::MockRequest.env_for('/runners/firefox') )
          runner_response = Rack::Response.new
          @session_id = Guid.new.to_s
          @driver = "Selenium Driver"
          stub(Selenium::SeleniumDriver).new('localhost', 4444, '*firefox', 'http://0.0.0.0:8080') do
            driver
          end
          stub(driver).start
          stub(driver).open
          stub(driver).session_id {session_id}
          stub(Thread).start.yields
          Thread.current[:connection] = connection

          @runner = Runners::FirefoxRunner.new
          runner.post(runner_request, runner_response)
        end

        it "resumes the FirefoxRunner" do
          body = "The text in the POST body"
          request = Rack::Request.new({'rack.input' => StringIO.new("text=#{body}&session_id=#{session_id}")})
          response = Rack::Response.new
          mock.proxy(Runners::FirefoxRunner).resume(session_id, body)
          mock(driver).stop
          stub(connection).send_data.once
          stub(connection).close_connection.once

          suite_finish.post(request, response)
        end
      end
    end
  end
  end
end

require File.expand_path("#{File.dirname(__FILE__)}/../../unit_spec_helper")

module JsTestCore
  module Resources
    describe Session do
      describe "GET /sessions/:session_id" do
        context "when there is no Runner with the :session_id" do
          it "responds with a 404" do
            session_id = "invalid_session_id"
            response = get(Session.path(session_id))
            response.body.should include("Could not find session #{session_id}")
            response.status.should == 404
          end
        end

        context "when there is a Runner with the :session_id" do
          attr_reader :driver, :session_id, :session_runner
          before do
            @driver = FakeSeleniumDriver.new
            @session_id = FakeSeleniumDriver::SESSION_ID
            stub(Selenium::Client::Driver).new('localhost', 4444, '*firefox', 'http://0.0.0.0:8080') do
              driver
            end

            post(Runner.path('firefox'))
            @session_runner = Runner.find(session_id)
            session_runner.should be_running
          end

          context "when a Runner with the :session_id is running" do
            it "responds with a 200 and status=running" do
              response = get(Session.path(session_id))

              body = "status=#{Resources::Session::RUNNING}"
              response.should be_http(200, {'Content-Length' => body.length.to_s}, body)
            end
          end

          context "when a Runner with the :session_id has completed" do
            context "when the session has a status of 'success'" do
              before do
                session_runner.finalize("")
                session_runner.should be_successful
              end

              it "responds with a 200 and status=success" do
                response = get(Session.path(session_id))

                body = "status=#{Resources::Session::SUCCESSFUL_COMPLETION}"
                response.should be_http(200, {'Content-Length' => body.length.to_s}, body)
              end
            end

            context "when the session has a status of 'failure'" do
              attr_reader :reason
              before do
                @reason = "Failure stuff"
                session_runner.finalize(reason)
                session_runner.should be_failed
              end

              it "responds with a 200 and status=failure and reason" do
                response = get(Session.path(session_id))

                body = "status=#{Resources::Session::FAILURE_COMPLETION}&reason=#{reason}"
                response.should be_http(200, {'Content-Length' => body.length.to_s}, body)
              end
            end
          end
        end
      end
    end
  end
end

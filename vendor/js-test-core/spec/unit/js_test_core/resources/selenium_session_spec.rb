require File.expand_path("#{File.dirname(__FILE__)}/../../unit_spec_helper")

module JsTestCore
  module Resources
    describe SeleniumSession do
      attr_reader :request, :driver, :session_id, :selenium_browser_start_command

      def self.before_with_selenium_browser_start_command(selenium_browser_start_command="selenium browser start command")
        before do
          @driver = FakeSeleniumDriver.new
          @session_id = FakeSeleniumDriver::SESSION_ID
          @selenium_browser_start_command = selenium_browser_start_command
          stub(Selenium::Client::Driver).new('localhost', 4444, selenium_browser_start_command, 'http://0.0.0.0:8080') do
            driver
          end
        end
      end

      after do
        Models::SeleniumSession.send(:instances).clear
      end

      describe "POST /selenium_sessions" do
        before_with_selenium_browser_start_command
        before do
          stub(Thread).start.yields
        end

        it "responds with a 200 and the session_id" do
          Models::SeleniumSession.find(session_id).should be_nil
          response = post(SeleniumSession.path("/"), {:selenium_browser_start_command => selenium_browser_start_command})
          body = "session_id=#{session_id}"
          response.should be_http(
            200,
            {'Content-Length' => body.length.to_s},
            body
          )
        end

        it "starts the Selenium Driver, creates a SessionID cookie, and opens the spec page" do
          mock(driver).start
          stub(driver).session_id {session_id}
          mock(driver).create_cookie("session_id=#{session_id}")
          mock(driver).open("/")
          mock(driver).open("/specs")

          mock(Selenium::Client::Driver).new('localhost', 4444, selenium_browser_start_command, 'http://0.0.0.0:8080') do
            driver
          end
          response = post(SeleniumSession.path("/"), {:selenium_browser_start_command => selenium_browser_start_command})
        end

        describe "when a selenium_host parameter is passed into the request" do
          it "starts the Selenium Driver with the passed in selenium_host" do
            mock(Selenium::Client::Driver).new('another-machine', 4444, selenium_browser_start_command, 'http://0.0.0.0:8080') do
              driver
            end
            response = post(SeleniumSession.path("/"), {
              :selenium_browser_start_command => selenium_browser_start_command,
              :selenium_host => "another-machine"
            })
          end
        end

        describe "when a selenium_host parameter is not passed into the request" do
          it "starts the Selenium Driver from localhost" do
            mock(Selenium::Client::Driver).new('localhost', 4444, selenium_browser_start_command, 'http://0.0.0.0:8080') do
              driver
            end
            response = post(SeleniumSession.path("/"), {
              :selenium_browser_start_command => selenium_browser_start_command,
              :selenium_host => ""
            })
          end
        end

        describe "when a selenium_port parameter is passed into the request" do
          it "starts the Selenium Driver with the passed in selenium_port" do
            mock(Selenium::Client::Driver).new('localhost', 4000, selenium_browser_start_command, 'http://0.0.0.0:8080') do
              driver
            end
            response = post(SeleniumSession.path("/"), {
              :selenium_browser_start_command => selenium_browser_start_command,
              :selenium_port => "4000"
            })
          end
        end

        describe "when a selenium_port parameter is not passed into the request" do
          it "starts the Selenium Driver from localhost" do
            mock(Selenium::Client::Driver).new('localhost', 4444, selenium_browser_start_command, 'http://0.0.0.0:8080') do
              driver
            end
            response = post(SeleniumSession.path("/"), {
              :selenium_browser_start_command => selenium_browser_start_command,
              :selenium_port => ""
            })
          end
        end

        describe "when a spec_url is passed into the request" do
          it "runs Selenium with the passed in host and part to run the specified spec session in Firefox" do
            mock(Selenium::Client::Driver).new('localhost', 4444, selenium_browser_start_command, 'http://another-host:8080') do
              driver
            end
            mock(driver).start
            stub(driver).create_cookie
            mock(driver).open("/")
            mock(driver).open("/specs/subdir")
            mock(driver).session_id {session_id}.at_least(1)

            response = post(SeleniumSession.path("/"), {
              :selenium_browser_start_command => selenium_browser_start_command,
              :spec_url => "http://another-host:8080/specs/subdir"
            })
          end
        end

        describe "when a spec_url is not passed into the request" do
          before do
            mock(Selenium::Client::Driver).new('localhost', 4444, selenium_browser_start_command, 'http://0.0.0.0:8080') do
              driver
            end
          end

          it "uses Selenium to run the entire spec session in Firefox" do
            mock(driver).start
            stub(driver).create_cookie
            mock(driver).open("/")
            mock(driver).open("/specs")
            mock(driver).session_id {session_id}.at_least(1)

            response = post(SeleniumSession.path("/"), {
              :selenium_browser_start_command => selenium_browser_start_command,
              :spec_url => ""
            })
          end
        end
      end

      describe "POST /selenium_sessions/firefox" do
        before_with_selenium_browser_start_command "*firefox"

        it "creates a selenium_session whose #driver started with '*firefox'" do
          Models::SeleniumSession.find(session_id).should be_nil
          response = post(SeleniumSession.path("/firefox"))
          body = "session_id=#{session_id}"
          response.should be_http(
            200,
            {'Content-Length' => body.length.to_s},
            body
          )

          selenium_session = Models::SeleniumSession.find(session_id)
          selenium_session.class.should == Models::SeleniumSession
          selenium_session.driver.should == driver
        end
      end

      describe "POST /selenium_sessions/iexplore" do
        before_with_selenium_browser_start_command "*iexplore"

        it "creates a selenium_session whose #driver started with '*iexplore'" do
          Models::SeleniumSession.find(session_id).should be_nil
          response = post(SeleniumSession.path("/iexplore"))
          body = "session_id=#{session_id}"
          response.should be_http(
            200,
            {'Content-Length' => body.length.to_s},
            body
          )

          selenium_session = Models::SeleniumSession.find(session_id)
          selenium_session.class.should == Models::SeleniumSession
          selenium_session.driver.should == driver
        end
      end

      describe "GET /sessions/:session_id" do
        context "when there is no Runner with the :session_id" do
          it "responds with a 404" do
            session_id = "invalid_session_id"
            response = get(SeleniumSession.path(session_id))
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

            post(SeleniumSession.path('firefox'))
            @session_runner = Models::SeleniumSession.find(session_id)
            session_runner.should be_running
          end

          context "when a Runner with the :session_id is running" do
            it "responds with a 200 and status=running" do
              response = get(SeleniumSession.path(session_id))

              body = "status=#{SeleniumSession::RUNNING}"
              response.should be_http(200, {'Content-Length' => body.length.to_s}, body)
            end
          end

          context "when a Runner with the :session_id has completed" do
            context "when the session has a status of 'success'" do
              before do
                session_runner.finish("")
                session_runner.should be_successful
              end

              it "responds with a 200 and status=success" do
                response = get(SeleniumSession.path(session_id))

                body = "status=#{SeleniumSession::SUCCESSFUL_COMPLETION}"
                response.should be_http(200, {'Content-Length' => body.length.to_s}, body)
              end
            end

            context "when the session has a status of 'failure'" do
              attr_reader :reason
              before do
                @reason = "Failure stuff"
                session_runner.finish(reason)
                session_runner.should be_failed
              end

              it "responds with a 200 and status=failure and reason" do
                response = get(SeleniumSession.path(session_id))

                body = "status=#{SeleniumSession::FAILURE_COMPLETION}&reason=#{reason}"
                response.should be_http(200, {'Content-Length' => body.length.to_s}, body)
              end
            end
          end
        end
      end

      describe "finish" do
        attr_reader :stdout
        before do
          @stdout = StringIO.new
          SeleniumSession.const_set(:STDOUT, stdout)
        end

        after do
          SeleniumSession.__send__(:remove_const, :STDOUT)
        end

        describe "POST /selenium_sessions/finish" do
          attr_reader :selenium_session
          context "when passed a :session_id parameter" do
            context "when :session_id does not match a registered SeleniumSession" do
              it "returns the text and writes the text to stdout" do
                Models::SeleniumSession.find(1).should be_nil

                text = "The text in the POST body"
                response = post(SeleniumSession.path("/finish", :session_id => 1), :text => text)
                response.should be_http(
                  200,
                  {},
                  text
                )
                stdout.string.should == "#{text}\n"
              end
            end

            context "when :session_id matches a registered SeleniumSession" do
              before do
                @driver = FakeSeleniumDriver.new
                @selenium_session = Models::SeleniumSession.new(:spec_url => "http://localhost:8080/specs")
                stub(selenium_session).driver {driver}
                driver.start
                @session_id = driver.session_id
                Models::SeleniumSession.register(selenium_session)
              end

              it "finishes the SeleniumSession" do
                text = "The text in the POST body"
                mock.proxy(selenium_session).finish(text)
                selenium_session.should be_running

                response = post(SeleniumSession.path("/finish", :session_id => session_id), :text => text)
                response.should be_http(
                  200,
                  {},
                  text
                )
                selenium_session.should_not be_running
              end
            end
          end

          context "when the session_id cookie is set" do
            context "when :session_id does not match a registered SeleniumSession" do
              it "returns the text and writes the text to stdout" do
                Models::SeleniumSession.find(1).should be_nil

                text = "The text in the POST body"
                response = post(SeleniumSession.path("/finish"), {:text => text}, {:cookie => "session_id=1"})
                response.should be_http(
                  200,
                  {},
                  text
                )
                stdout.string.should == "#{text}\n"
              end
            end

            context "when :session_id matches a registered SeleniumSession" do
              attr_reader :selenium_session
              before do
                @driver = FakeSeleniumDriver.new
                @selenium_session = Models::SeleniumSession.new(:spec_url => "http://localhost:8080/specs")
                stub(selenium_session).driver {driver}
                driver.start
                @session_id = driver.session_id
                Models::SeleniumSession.register(selenium_session)
              end

              it "finishes the SeleniumSession" do
                text = "The text in the POST body"
                mock.proxy(selenium_session).finish(text)
                selenium_session.should be_running

                response = post(SeleniumSession.path("/finish"), {:text => text}, {:cookie => "session_id=#{session_id}"})
                response.should be_http(
                  200,
                  {},
                  text
                )
                selenium_session.should_not be_running
              end
            end
          end
        end

        describe "POST /sessions/:session_id/finish" do
          it "returns the text and writes the text to stdout" do
            text = "The text in the POST body"

            response = post(SeleniumSession.path("/:session_id/finish", :session_id => 1), :text => text)
            response.should be_http(
              200,
              {},
              text
            )
            stdout.string.should == "#{text}\n"
          end
        end

      end
    end
  end
end

require File.expand_path("#{File.dirname(__FILE__)}/../../unit_spec_helper")

module JsTestCore
  module Resources
    describe SuiteFinish do
      attr_reader :stdout
      before do
        @stdout = StringIO.new
        SuiteFinish.const_set(:STDOUT, stdout)
      end

      after do
        SuiteFinish.__send__(:remove_const, :STDOUT)
      end

      describe "POST /suites/:suite_id/finish" do
        context "when :suite_id == 'user'" do
          it "writes the body of the request to stdout" do
            stub(connection).send_head
            stub(connection).send_body

            text = "The text in the POST body"
            body = "text=#{text}"
            connection.receive_data("POST /suites/user/finish HTTP/1.1\r\nHost: _\r\nContent-Length: #{body.length}\r\n\r\n#{body}")
            stdout.string.should == "#{text}\n"
          end

          it "sends an empty body" do
            text = "The text in the POST body"
            body = "text=#{text}"

            mock(connection).send_head
            mock(connection).send_body("")
            connection.receive_data("POST /suites/user/finish HTTP/1.1\r\nHost: _\r\nContent-Length: #{body.length}\r\n\r\n#{body}")
          end
        end

        context "when :suite_id != 'user'" do
          attr_reader :suite_id, :driver
          before do
            @suite_id = "DEADBEEF"
            @driver = "Selenium Driver"
            stub(Selenium::SeleniumDriver).new('localhost', 4444, '*firefox', 'http://0.0.0.0:8080') do
              driver
            end
            stub(driver).start
            stub(driver).open
            stub(driver).session_id {suite_id}
            stub(Thread).start.yields

            firefox_connection = Thin::JsTestCoreConnection.new(Guid.new)
            stub(firefox_connection).send_head
            stub(firefox_connection).send_body
            stub(firefox_connection).close_connection
            firefox_connection.receive_data("POST /runners/firefox HTTP/1.1\r\nHost: _\r\n\r\n")
          end

          it "calls Runner.finalize" do
            text = "The text in the POST body"
            body = "text=#{text}"
            stub(connection).send_head
            stub(connection).send_body
            mock.proxy(Runners::Runner).finalize(suite_id.to_s, text)
            mock(driver).stop
            stub(connection).close_connection

            connection.receive_data("POST /suites/#{suite_id}/finish HTTP/1.1\r\nHost: _\r\nContent-Length: #{body.length}\r\n\r\n#{body}")
          end

          it "responds with a blank body" do
            stub(driver).stop
            stub(connection).close_connection

            mock(connection).send_head
            mock(connection).send_body("")
            connection.receive_data("POST /suites/#{suite_id}/finish HTTP/1.1\r\nHost: _\r\nContent-Length: 0\r\n\r\n")
          end
        end
      end
    end
  end
end

module JsTestCore
  module Resources
    class SeleniumSession < Resource
      map "/selenium_sessions"

      post "/" do
        do_post params["selenium_browser_start_command"]
      end

      post "/firefox" do
        do_post "*firefox"
      end

      post '/iexplore' do |env, name|
        do_post "*iexplore"
      end

      get "/:session_id" do
        do_get
      end

      post "/finish" do
        do_finish
      end

      post "/:session_id/finish" do
        do_finish
      end

      include FileUtils
      RUNNING = 'running'
      SUCCESSFUL_COMPLETION = 'success'
      FAILURE_COMPLETION = 'failure'

      protected

      def do_get
        selenium_session = Models::SeleniumSession.find(session_id)
        if selenium_session
          body = if selenium_session.running?
            "status=#{RUNNING}"
          else
            if selenium_session.successful?
              "status=#{SUCCESSFUL_COMPLETION}"
            else
              "status=#{FAILURE_COMPLETION}&reason=#{selenium_session.run_result}"
            end
          end
          [
            200,
            {'Content-Length' => body.length},
            body
          ]
        else
          body = Representations::NotFound.new(:message => "Could not find session #{session_id}").to_s
          [
            404,
            {
              "Content-Type" => "text/html",
              "Content-Length" => body.size.to_s
            },
            body
          ]
        end
      end

      def do_finish
        if selenium_session = Models::SeleniumSession.find(session_id)
          selenium_session.finish(request['text'])
        else
          STDOUT.puts request['text']
        end
        [200, {}, request['text']]
      end

      def session_id
        params["session_id"] || request.cookies["session_id"]
      end

      def do_post(selenium_browser_start_command)
        selenium_session = Models::SeleniumSession.new({
          :spec_url => request['spec_url'].to_s == "" ? full_spec_suite_url : request['spec_url'],
          :selenium_browser_start_command => selenium_browser_start_command,
          :selenium_host => request['selenium_host'].to_s == "" ? 'localhost' : request['selenium_host'].to_s,
          :selenium_port => request['selenium_port'].to_s == "" ? 4444 : Integer(request['selenium_port'])
        })
        selenium_session.start

        body = "session_id=#{selenium_session.session_id}"
        [
          200,
          {
            "Content-Length" => body.length  
          },
          body
        ]
      end

      def full_spec_suite_url
        "#{Configuration.root_url}/specs"
      end
    end
  end
end

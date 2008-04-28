module JsTestCore
  module Resources
    class SuiteFinish
      attr_reader :suite
      def initialize(suite)
        @suite = suite
      end

      def post(request, response)
        if session_id = request['session_id']
          Runners::FirefoxRunner.resume(session_id, request['text'])
        else
          STDOUT.puts request['text']
        end
      end
    end
  end
end
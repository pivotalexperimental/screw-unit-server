module JsTestCore
  module Resources
    class SuiteFinish
      attr_reader :suite
      def initialize(suite)
        @suite = suite
      end

      def post(request, response)
        guid = request['guid']
        if guid
          Runners::FirefoxRunner.resume(guid, request['text'])
        else
          STDOUT.puts request['text']
        end
        ""
      end
    end
  end
end
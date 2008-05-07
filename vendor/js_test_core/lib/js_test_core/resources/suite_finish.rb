module JsTestCore
  module Resources
    class SuiteFinish
      attr_reader :suite
      def initialize(suite)
        @suite = suite
      end

      def post(request, response)
        if suite.id == 'user'
          STDOUT.puts request['text']
        else
          Runners::FirefoxRunner.resume(suite.id, request['text'])
        end
      end
    end
  end
end
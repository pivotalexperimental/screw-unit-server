module JsTestCore
  module Resources
    class Suite
      class << self
        def locate(id)
          new id
        end
      end

      attr_reader :id
      def initialize(id)
        @id = id
      end

      def locate(name)
        if name == 'finish'
          SuiteFinish.new self
        else
          raise ArgumentError, "Invalid path: #{name}"
        end
      end
    end
  end
end
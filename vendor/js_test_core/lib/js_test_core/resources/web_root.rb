module JsTestCore
  module Resources
    class WebRoot
      LOCATIONS = [
        ['', lambda do |web_root|
          web_root
        end],
        ['core', lambda do
          Resources::Dir.new(JsTestCore::Server.core_path, "/core")
        end],
        ['implementations', lambda do
          Resources::Dir.new(JsTestCore::Server.implementation_root_path, "/implementations")
        end],
        ['suites', lambda do
          Resources::Suite
        end],
        ['runners', lambda do
          Resources::Runners.new
        end]
      ]

      class << self
        attr_accessor :dispatch_strategy
        def dispatch_specs
          self.dispatch_strategy = :specs
        end
      end

      attr_reader :public_path
      def initialize(public_path)
        @public_path = ::File.expand_path(public_path)
      end

      def locate(name)
        if self.class.dispatch_strategy == :specs && name == 'specs'
          return JsTestCore::Resources::Specs::SpecDir.new(JsTestCore::Server.spec_root_path, "/specs")
        end

        location, initializer = LOCATIONS.find do |location|
          location.first == name
        end
        if initializer
          initializer.call(self)
        else
          potential_file_in_public_path = "#{public_path}/#{name}"
          if ::File.directory?(potential_file_in_public_path)
            Resources::Dir.new(potential_file_in_public_path, "/#{name}")
          elsif ::File.exists?(potential_file_in_public_path)
            Resources::File.new(potential_file_in_public_path, "/#{name}")
          else
            Resources::FileNotFound.new(name)
          end
        end
      end

      def get(request, response)
        response.status = 301
        response['Location'] = "/#{self.class.dispatch_strategy}"
      end
    end
  end
end
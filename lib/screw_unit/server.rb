module ScrewUnit
  class Server
    class << self
      def start
        require "thin"
        Thin::Runner.new([
          "--port", "8080",
          "--rackup", File.expand_path("#{File.dirname(__FILE__)}/../../standalone.ru"),
          "start"]
        ).run!
      end

      def standalone_rackup(rack_builder)
        require "sinatra"

        ScrewUnit.spec_root_path = ENV["SCREW_UNIT_SPEC_ROOT"] || File.expand_path("./spec/javascripts")
        if File.directory?(ScrewUnit.spec_root_path)
          puts "SCREW_UNIT_SPEC_ROOT is #{ScrewUnit.spec_root_path}"
        else
          raise "SCREW_UNIT_SPEC_ROOT #{ScrewUnit.spec_root_path} must be a directory"
        end

        ScrewUnit.public_path = ENV["SCREW_UNIT_PUBLIC"] || File.expand_path("./public")
        if File.directory?(ScrewUnit.public_path)
          puts "SCREW_UNIT_PUBLIC is #{ScrewUnit.public_path}"
        else
          raise "SCREW_UNIT_PUBLIC #{ScrewUnit.public_path} must be a directory"
        end

        rack_builder.use ScrewUnit::App
        rack_builder.run Sinatra::Application
      end
    end
  end
end
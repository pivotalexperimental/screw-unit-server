module JsTestCore
  class Server
    class << self
      attr_accessor :rackup_path
      def start
        require "thin"
        Thin::Runner.new([
          "--port", "8080",
          "--rackup", File.expand_path(rackup_path),
          "start"]
        ).run!
      end

      def standalone_rackup(rack_builder, spec_root_env_var_name="JS_SPEC_ROOT", public_env_var_name="JS_PUBLIC")
        require "sinatra"

        JsTestCore.spec_root_path = ENV[spec_root_env_var_name] || File.expand_path("./spec/javascripts")
        if File.directory?(JsTestCore.spec_root_path)
          puts "#{spec_root_env_var_name} is #{JsTestCore.spec_root_path}"
        else
          raise "#{spec_root_env_var_name} #{JsTestCore.spec_root_path} must be a directory"
        end

        JsTestCore.public_path = ENV[public_env_var_name] || File.expand_path("./public")
        if File.directory?(JsTestCore.public_path)
          puts "#{public_env_var_name} is #{JsTestCore.public_path}"
        else
          raise "#{public_env_var_name} #{JsTestCore.public_path} must be a directory"
        end

        rack_builder.use JsTestCore::App
        rack_builder.run Sinatra::Application
      end
    end
  end
end
require "rubygems"
require "timeout"
require "lsof"
dir = File.dirname(__FILE__)
$LOAD_PATH.unshift "#{dir}/../../lib"
require "js_test_core"
require "nokogiri"

module WaitFor
  extend self
  def wait_for(time=5)
    Timeout.timeout(time) do
      loop do
        value = yield
        return value if value
      end
    end
  end
end

class FunctionalSpecServerStarter
  class << self
    include WaitFor
    def call(threaded=true)
      return if $js_test_server_started

      Lsof.kill(8080)
      wait_for do
        !Lsof.running?(8080)
      end

      dir = File.dirname(__FILE__)
      Dir.chdir("#{dir}/../../") do
        Thread.start do
          start_thin_server
        end
      end

      wait_for do
        Lsof.running?(8080)
      end
      $js_test_server_started = true
    end

    def start_thin_server
      system("bin/js-test-server --spec-path=#{spec_path} --root-path=#{root_path} --framework-name=#{framework_name} --framework-path=#{framework_path}")
      at_exit do
        puts "#{__FILE__}:#{__LINE__}"
        Lsof.kill(8080)
      end
    end

    def framework_name
      "screw-unit"
    end

    def framework_path
      File.expand_path("#{dir}/../../../screw-unit/lib")
    end

    def spec_path
      File.expand_path("#{dir}/../example_spec")
    end

    def root_path
      File.expand_path("#{dir}/../example_root")
    end

    def dir
      dir = File.dirname(__FILE__)
    end
  end
end

if $0 == __FILE__
  FunctionalSpecServerStarter.call(false)
end
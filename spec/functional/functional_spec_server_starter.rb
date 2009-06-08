require "rubygems"
require "timeout"
require "lsof"
dir = File.dirname(__FILE__)
$LOAD_PATH.unshift "#{dir}/../../lib"
require "screw_unit"
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
      return if $screw_unit_server_started

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
      $screw_unit_server_started = true
    end

    def start_thin_server
      system("bin/screw_unit_server #{spec_root_path} #{public_path}")
      at_exit do
        Lsof.kill(8080)
      end
    end

    def spec_root_path
      File.expand_path("#{dir}/../example_specs")
    end

    def public_path
      File.expand_path("#{dir}/../example_public")
    end

    def dir
      dir = File.dirname(__FILE__)
    end
  end
end

if $0 == __FILE__
  FunctionalSpecServerStarter.call(false)
end
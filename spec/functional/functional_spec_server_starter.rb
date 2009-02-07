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
      if threaded
        Thread.start do
          ScrewUnit::Server.run(spec_root_path, implementation_root_path, public_path)
        end
      else
        ScrewUnit::Server.run(spec_root_path, implementation_root_path, public_path)
      end
      wait_for do
        Lsof.running?(8080)
      end
      $screw_unit_server_started = true
    end

    def spec_root_path
      File.expand_path("#{dir}/../example_specs")
    end

    def public_path
      File.expand_path("#{dir}/../example_public")
    end

    def implementation_root_path
      File.expand_path("#{public_path}/javascripts")
    end

    def dir
      dir = File.dirname(__FILE__)
    end
  end
end

if $0 == __FILE__
  FunctionalSpecServerStarter.call(false)
end
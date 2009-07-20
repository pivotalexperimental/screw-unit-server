require "rubygems"
gem "thin", ">=1.2.1"
gem "erector", ">=0.6.7"
gem "selenium-client"

dir = File.dirname(__FILE__)
$LOAD_PATH.unshift File.expand_path("#{dir}/../vendor/lucky-luciano/lib")
require "lucky_luciano"

require "timeout"
require "selenium/client"
require "trollop"
require "json"
require "erector"

require "#{dir}/js_test_core/configuration"

require "#{dir}/js_test_core/resources"
require "#{dir}/js_test_core/representations"
require "#{dir}/js_test_core/server"
require "#{dir}/js_test_core/client"
require "#{dir}/js_test_core/app"

module JsTestCore
  class << self
    Configuration.instance = Configuration.new

    def method_missing(method_name, *args, &block)
      if Configuration.instance.respond_to?(method_name)
        Configuration.instance.send(method_name, *args, &block)
      else
        super
      end
    end
  end
end

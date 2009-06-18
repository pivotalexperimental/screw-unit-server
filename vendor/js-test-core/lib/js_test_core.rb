require "rubygems"
gem "thin", ">=1.2.1"
gem "erector", ">=0.6.7"
gem "selenium-client"

dir = File.dirname(__FILE__)
$LOAD_PATH.unshift File.expand_path("#{dir}/../vendor/lucky-luciano/lib")
require "lucky_luciano"

require "fileutils"
require "tmpdir"
require "timeout"
require "cgi"
require "net/http"
require "selenium/client"
require "optparse"
require "erector"

require "#{dir}/js_test_core/configuration"

require "#{dir}/js_test_core/extensions"
require "#{dir}/js_test_core/models"
require "#{dir}/js_test_core/resources"
require "#{dir}/js_test_core/representations"
require "#{dir}/js_test_core/server"

require "#{dir}/js_test_core/client"
require "#{dir}/js_test_core/selenium_server_configuration"

require "#{dir}/js_test_core/app"

module JsTestCore
  DEFAULT_HOST = "0.0.0.0"
  DEFAULT_PORT = 8080

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

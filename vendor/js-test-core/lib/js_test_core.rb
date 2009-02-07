require "rubygems"
gem "thin", ">=0.8.0"

dir = File.dirname(__FILE__)
$LOAD_PATH.unshift File.expand_path("#{dir}/../vendor/thin-rest/lib")
require "thin_rest"

# This causes errors to be printed to STDOUT.
Thin::Logging.silent = false
Thin::Logging.debug = true

require "fileutils"
require "tmpdir"
require "timeout"
require "cgi"
require "net/http"
gem "selenium-client"
require "selenium/client"
require "optparse"
require "erector"

require "#{dir}/js_test_core/extensions"
require "#{dir}/js_test_core/thin"
require "#{dir}/js_test_core/rack"
require "#{dir}/js_test_core/resources"
require "#{dir}/js_test_core/representations"
require "#{dir}/js_test_core/selenium"

require "#{dir}/js_test_core/client"
require "#{dir}/js_test_core/selenium_server_configuration"
require "#{dir}/js_test_core/server"
require "#{dir}/js_test_core/rails_server"

module JsTestCore
  DEFAULT_HOST = "0.0.0.0"
  DEFAULT_PORT = 8080

  class << self
    attr_accessor :core_path
  end
end

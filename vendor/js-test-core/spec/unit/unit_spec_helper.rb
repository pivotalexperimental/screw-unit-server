require "rubygems"
require "spec"
require "spec/autorun"
require "rack/test"
ARGV.push("-b")

dir = File.dirname(__FILE__)
LIBRARY_ROOT_DIR = File.expand_path("#{dir}/../..")
$LOAD_PATH.unshift File.expand_path("#{LIBRARY_ROOT_DIR}/lib")
require "js_test_core"
require "nokogiri"
require "guid"
require "#{LIBRARY_ROOT_DIR}/spec/spec_helpers/example_group"
require "#{LIBRARY_ROOT_DIR}/spec/spec_helpers/fake_selenium_driver"
require "#{LIBRARY_ROOT_DIR}/spec/spec_helpers/show_test_exceptions"

Spec::Runner.configure do |config|
  config.mock_with :rr
end

Sinatra::Application.use ShowTestExceptions
Sinatra::Application.set :raise_errors, true

Sinatra::Application.use(JsTestCore::App)
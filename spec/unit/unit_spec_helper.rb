require "rubygems"
require "spec"
require "spec/autorun"
require "rack/test"
ARGV.push("-b")

dir = File.dirname(__FILE__)
LIBRARY_ROOT_DIR = File.expand_path("#{dir}/../..")
$LOAD_PATH.unshift File.expand_path("#{LIBRARY_ROOT_DIR}/lib")
require "screw_unit"
require "nokogiri"
require "guid"
require "#{LIBRARY_ROOT_DIR}/vendor/js-test-core/spec/spec_helpers/be_http"
require "#{LIBRARY_ROOT_DIR}/vendor/js-test-core/spec/spec_helpers/show_test_exceptions"

Spec::Runner.configure do |config|
  config.mock_with :rr
end

Sinatra::Application.use ShowTestExceptions
Sinatra::Application.set :raise_errors, true

Sinatra::Application.use(ScrewUnit::App)

class Spec::ExampleGroup
  include Rack::Test::Methods
  include BeHttp
  
  attr_reader :spec_root_path, :implementation_root_path, :public_path, :server, :connection
  before(:all) do
    dir = File.dirname(__FILE__)
    @spec_root_path = File.expand_path("#{dir}/../example_specs")
    @implementation_root_path = File.expand_path("#{dir}/../example_public/javascripts")
    @public_path = File.expand_path("#{dir}/../example_public")
  end

  before(:each) do
    JsTestCore::Configuration.instance.spec_root_path = spec_root_path
    JsTestCore::Configuration.instance.implementation_root_path = implementation_root_path
    JsTestCore::Configuration.instance.public_path = public_path
  end

  def app
    Sinatra::Application
  end

  def core_path
    JsTestCore::Server.core_path
  end
end

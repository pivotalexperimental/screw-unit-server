require "rubygems"
require "spec"
require "spec/autorun"
require "selenium_rc"
require "thin"
dir = File.dirname(__FILE__)
LIBRARY_ROOT_DIR = File.expand_path("#{dir}/../..")
require "#{LIBRARY_ROOT_DIR}/vendor/js-test-core/spec/spec_helpers/be_http"
require "#{LIBRARY_ROOT_DIR}/vendor/js-test-core/spec/spec_helpers/show_test_exceptions"
require "#{dir}/functional_spec_server_starter"
ARGV.push("-b")

Spec::Runner.configure do |config|
  config.mock_with :rr
end

Sinatra::Application.use ShowTestExceptions
Sinatra::Application.set :raise_errors, true

Sinatra::Application.use(ScrewUnit::App)


class Spec::ExampleGroup
  include WaitFor
  attr_reader :spec_root_path, :public_path

  before(:all) do
    @spec_root_path = FunctionalSpecServerStarter.spec_root_path
    @public_path = FunctionalSpecServerStarter.public_path
    unless SeleniumRC::Server.service_is_running?
      Thread.start do
        SeleniumRC::Server.boot
      end
    end
    FunctionalSpecServerStarter.call
    TCPSocket.wait_for_service :host => "0.0.0.0", :port => "4444"
  end

  def root_url
    "http://localhost:8080"
  end
end

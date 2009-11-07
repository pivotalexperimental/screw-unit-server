require "rubygems"
require "spec"
require "spec/autorun"
require "selenium_rc"
require "thin"
dir = File.dirname(__FILE__)
LIBRARY_ROOT_DIR = File.expand_path("#{dir}/../..")
require File.expand_path("#{dir}/../spec_helpers/be_http")
require File.expand_path("#{dir}/../spec_helpers/show_test_exceptions")
require "#{dir}/functional_spec_server_starter"
ARGV.push("-b")

Spec::Runner.configure do |config|
  config.mock_with :rr
end

Sinatra::Application.use ShowTestExceptions
Sinatra::Application.set :raise_errors, true

Sinatra::Application.use(JsTestCore::App)


class Spec::ExampleGroup
  include WaitFor
  attr_reader :spec_path, :root_path

  before(:all) do
    @spec_path = FunctionalSpecServerStarter.spec_path
    @root_path = FunctionalSpecServerStarter.root_path
    unless SeleniumRC::Server.service_is_running?
      Thread.start do
        SeleniumRC::Server.boot
      end
    end
    FunctionalSpecServerStarter.call
    TCPSocket.wait_for_service :host => "0.0.0.0", :port => "4444"
  end

  def root_url
    "http://#{JsTestCore::Server::DEFAULTS[:host]}:#{JsTestCore::Server::DEFAULTS[:port]}"
  end
end

require "rubygems"
dir = File.dirname(__FILE__)
$LOAD_PATH.unshift "#{dir}/../../../plugins/rspec/lib"
require "spec"

$LOAD_PATH.unshift "#{dir}/../../lib"
require "js_test_core"
require "hpricot"

Spec::Runner.configure do |config|
  config.mock_with :rr
end

module Spec
  module Matchers
    class Exist
      def matches?(actual)
        @actual = actual
        !@actual.nil?
      end
    end
  end
end

class Spec::Example::ExampleGroup
  class << self
    def thin_logging
      @thin_logging = true if @thin_logging.nil?
      @thin_logging
    end

    attr_writer :thin_logging
  end
end

class JsTestCoreTestDir < JsTestCore::Resources::Dir
  def get(request, response)

  end
end

module Spec::Example::ExampleMethods
  attr_reader :core_path, :spec_root_path, :implementation_root_path, :public_path, :server, :connection
  before(:all) do
    dir = File.dirname(__FILE__)
    @core_path = File.expand_path("#{dir}/../example_core")
    JsTestCore.core_path = core_path
    @spec_root_path = File.expand_path("#{dir}/../example_specs")
    @implementation_root_path = File.expand_path("#{dir}/../example_public/javascripts")
    @public_path = File.expand_path("#{dir}/../example_public")
  end

  before(:each) do
    JsTestCore::Server.instance = JsTestCore::Server.new(spec_root_path, implementation_root_path, public_path)
    stub(EventMachine).run do
      raise "You need to mock calls to EventMachine.run or the process will hang"
    end
    stub(EventMachine).start_server do
      raise "You need to mock calls to EventMachine.start_server or the process will hang"
    end
    stub(EventMachine).send_data do
      raise "Calls to EventMachine.send_data must be mocked or stubbed"
    end
    @connection = Thin::JsTestCoreConnection.new(Guid.new)
    stub(EventMachine).send_data {raise "EventMachine.send_data must be handled"}
    stub(EventMachine).close_connection {raise "EventMachine.close_connection must be handled"}
    @server = JsTestCore::Server.instance
    Thin::Logging.silent = !self.class.thin_logging
    Thin::Logging.debug = self.class.thin_logging
  end

  after(:each) do
    JsTestCore::Resources::WebRoot.dispatch_strategy = nil
    Thin::Logging.silent = true
    Thin::Logging.debug = false
  end

  def get(url, params={})
    request(:get, url, params)
  end

  def post(url, params={})
    request(:post, url, params)
  end

  def put(url, params={})
    request(:put, url, params)
  end

  def delete(url, params={})
    request(:delete, url, params)
  end

  def env_for(method, url, params)
    Rack::MockRequest.env_for(url, params.merge({:method => method.to_s.upcase, 'js_test_core.connection' => connection}))
  end

  def create_request(method, url, params={})
    env = env_for(method, url, params)
    server.call(env)[2]
  end
  alias_method :request, :create_request

  def spec_file(relative_path)
    absolute_path = spec_root_path + relative_path
    JsTestCore::Resources::File.new(absolute_path, "/specs#{relative_path}")
  end

  def spec_dir(relative_path="")
    absolute_path = spec_root_path + relative_path
    JsTestCore::Resources::Specs::SpecDir.new(absolute_path, "/specs#{relative_path}")
  end

  def contain_spec_file_with_correct_paths(path_relative_to_spec_root)
    expected_absolute_path = spec_root_path + path_relative_to_spec_root
    expected_relative_path = "/specs" + path_relative_to_spec_root

    ::Spec::Matchers::SimpleMatcher.new(expected_relative_path) do |globbed_files|
      file = globbed_files.find do |file|
        file.absolute_path == expected_absolute_path
      end
      file && file.relative_path == expected_relative_path
    end
  end
end

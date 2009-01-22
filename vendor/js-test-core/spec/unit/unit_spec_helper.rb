require "rubygems"
require "spec"

dir = File.dirname(__FILE__)
$LOAD_PATH.unshift File.expand_path("#{dir}/../../lib")
require "js_test_core"
require "hpricot"
require "guid"

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

class JsTestCoreTestDir < JsTestCore::Resources::Dir
  def get

  end
end

class Spec::ExampleGroup
  class << self
    def thin_logging
      @thin_logging = true if @thin_logging.nil?
      @thin_logging
    end

    attr_writer :thin_logging
  end
  
  attr_reader :core_path, :spec_root_path, :implementation_root_path, :public_path, :server, :connection
  before(:all) do
    dir = File.dirname(__FILE__)
    @core_path = File.expand_path("#{dir}/../example_core")
    JsTestCore.core_path = core_path
    @spec_root_path = File.expand_path("#{dir}/../example_specs")
    @implementation_root_path = File.expand_path("#{dir}/../example_public/javascripts")
    @public_path = File.expand_path("#{dir}/../example_public")
    stub(Thread).start.yields
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
    @connection = create_connection
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

  def create_connection(guid=Guid.new)
    Thin::JsTestCoreConnection.new(Guid.new)
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

  def create_request(method, path, params={})
    body = params.map do |key, value|
      "#{URI.escape(key)}=#{URI.escape(value)}"
    end.join("&")
    connection.receive_data "#{method.to_s.upcase} #{path} HTTP/1.1\r\nHost: _\r\nContent-Length: #{body.length}\r\n\r\n#{body}"
    connection.response
  end
  alias_method :request, :create_request

  def spec_dir(relative_path="")
    absolute_path = spec_root_path + relative_path
    JsTestCore::Resources::Specs::SpecDir.new(:connection => connection, :absolute_path => absolute_path, :relative_path => "/specs#{relative_path}")
  end

  def contain_spec_file_with_correct_paths(path_relative_to_spec_root)
    expected_absolute_path = spec_root_path + path_relative_to_spec_root
    expected_relative_path = "/specs" + path_relative_to_spec_root

    ::Spec::Matchers::SimpleMatcher.new(expected_relative_path) do |globbed_files|
      file = globbed_files.find do |file|
        file.absolute_path == expected_absolute_path
      end
      raise "Did not find file with absolute path of #{expected_absolute_path.inspect}" unless file
      file.relative_path == expected_relative_path
    end
  end

  def stub_send_data
    stub(EventMachine).send_data do |signature, data, data_length|
      data_length
    end
  end
end

class FakeSeleniumDriver
  SESSION_ID = "DEADBEEF"
  attr_reader :session_id

  def initialize
    @session_id = nil
  end

  def start
    @session_id = SESSION_ID
  end

  def stop
    @session_id = nil
  end

  def open(url)
  end

  def create_cookie(key_value, options="")

  end

  def session_started?
    !!@session_id
  end
end

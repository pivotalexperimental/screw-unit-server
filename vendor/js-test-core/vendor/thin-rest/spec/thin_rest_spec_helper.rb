dir = File.dirname(__FILE__)
$LOAD_PATH.unshift(File.expand_path("#{dir}/../lib"))
require "thin_rest"
require "spec"
require "spec/autorun"
require "guid"

Spec::Runner.configure do |config|
  config.mock_with :rr
end

class Spec::ExampleGroup
  class << self
    def thin_logging
      if @thin_logging.nil?
        return false
      else
        @thin_logging
      end
    end
    attr_writer :thin_logging
  end

  attr_reader :connection
  before do
    @connection = create_connection

    stub(EventMachine).send_data {raise "EventMachine.send_data needs to be stubbed or mocked out"}
    stub(EventMachine).close_connection {raise "EventMachine.close_connection needs to be stubbed or mocked out"}
    stub(EventMachine).close_connection_after_writing {raise "EventMachine.close_connection_after_writing needs to be stubbed or mocked out"}
    stub(EventMachine).set_comm_inactivity_timeout {raise "EventMachine.set_comm_inactivity_timeout needs to be stubbed or mocked out"}
    stub(EventMachine).report_connection_error_status {0}
    stub(EventMachine).add_timer
    Thin::Logging.silent = !self.class.thin_logging
    Thin::Logging.debug = self.class.thin_logging
  end

  after(:each) do
    Thin::Logging.silent = true
    Thin::Logging.debug = false
  end

  def create_connection(guid = Guid.new.to_s)
    connection = TestConnection.new(guid)
    connection.backend = Object.new
    stub(connection.backend).connection_finished
    connection
  end

  def stub_send_data
    stub(EventMachine).send_data do |signature, data, data_length|
      data_length
    end
  end
end

class TestConnection < ThinRest::Connection
  def root_resource
    Root.new(:connection => self)
  end
end

class Root < ThinRest::Resources::Resource
  property :connection
  route 'subresource', 'Subresource'
  route 'another_subresource', 'AnotherSubresource'
  route 'block_subresource' do |properties, name|
    BlockSubresource.new(properties.merge(:foobar => foobar))
  end
  route 'error_subresource', 'ErrorSubresource'
  route 'wrong_property' do |properties, name|
    WrongPropertySubresource.new(properties.merge(:baz => name))
  end


  def foobar
    :baz
  end
end

class Subresource < ThinRest::Resources::Resource
  def do_get
    "GET response"
  end

  def do_post
    "POST response"
  end

  def do_put
    "PUT response"
  end

  def do_delete
    "DELETE response"
  end
end

class AnotherSubresource < ThinRest::Resources::Resource
  def do_get
    "Another GET response"
  end

  def do_post
    "Another POST response"
  end

  def do_put
    "Another PUT response"
  end

  def do_delete
    "Another DELETE response"
  end
end

class BlockSubresource < ThinRest::Resources::Resource
  property :foobar
end

class ErrorSubresource < ThinRest::Resources::Resource
  ERROR_MESSAGE = "An Error"

  def get
    raise ERROR_MESSAGE
  end
end

class WrongPropertySubresource < ThinRest::Resources::Resource
  property :foobar
  def get
    "Wrong Property"
  end
end
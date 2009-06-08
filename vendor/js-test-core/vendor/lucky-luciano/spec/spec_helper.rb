require "rubygems"
require "spec"
require "spec/autorun"
require 'rack/test'
require "rr"
require "sinatra"

ARGV.push("-b")

dir = File.dirname(__FILE__)
$:.unshift File.expand_path("#{dir}/../lib")
require "lucky_luciano"
require "lucky_luciano/rspec"

set :environment, :test

class Spec::ExampleGroup
  include BeHttp
  class << self
    def macro(name, &block)
      eigen do
        define_method(name, &block)
      end
    end

    def eigen(&block)
      eigen_class = (class << self; self; end)
      eigen_class.class_eval(&block)
      eigen_class
    end
  end
  
  include Rack::Test::Methods

  before do
    app.routes.clear
    Sinatra::Default.routes.clear
    app.reset!
  end

  def app
    Sinatra::Application
  end
end

Spec::SeleniumSession.configure do |config|
  config.mock_with :rr
end

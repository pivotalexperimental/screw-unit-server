require "rubygems"

dir = File.dirname(__FILE__)
$:.unshift(File.expand_path("#{dir}/../vendor/js_test_core/lib"))
require "js_test_core"
JsTestCore::Resources::WebRoot.dispatch_specs

require "#{dir}/screw_unit/resources"

module ScrewUnit
  DEFAULT_HOST = JsTestCore::DEFAULT_HOST
  DEFAULT_PORT = JsTestCore::DEFAULT_PORT

  Server = JsTestCore::Server
  RailsServer = JsTestCore::RailsServer
  Client = JsTestCore::Client
end
JsTestCore.core_path = File.expand_path("#{dir}/../core/lib")

class JsTestCore::Resources::Specs::SpecFile
  include ScrewUnit::Resources::Spec
end

class JsTestCore::Resources::Specs::SpecDir
  include ScrewUnit::Resources::Spec
end

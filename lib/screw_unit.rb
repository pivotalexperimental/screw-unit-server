require "rubygems"

dir = File.dirname(__FILE__)
$:.unshift(File.expand_path("#{dir}/../vendor/js-test-core/lib"))
require "js_test_core"

require "#{dir}/screw_unit/representations"

JsTestCore.core_path = File.expand_path("#{dir}/../core/lib")
JsTestCore::Resources::SpecFile.spec_representation_class = ScrewUnit::Representations::Spec
JsTestCore::Server.rackup_path = File.expand_path("#{dir}/../standalone.ru")
module ScrewUnit
  include JsTestCore

  class << self
    def method_missing(method_name, *args, &block)
      if JsTestCore::Configuration.instance.respond_to?(method_name)
        JsTestCore::Configuration.instance.send(method_name, *args, &block)
      else
        super
      end
    end
  end
end

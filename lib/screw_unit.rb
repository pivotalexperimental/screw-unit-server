require "rubygems"

dir = File.dirname(__FILE__)
$:.unshift(File.expand_path("#{dir}/../vendor/js-test-core/lib"))
require "js_test_core"

require "#{dir}/screw_unit/representations"

JsTestCore.core_path = File.expand_path("#{dir}/../core/lib")
JsTestCore::Resources::Specs::Spec.spec_representation_class = ScrewUnit::Representations::Spec
module ScrewUnit
  include JsTestCore
end

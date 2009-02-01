dir = File.dirname(__FILE__)

module JsTestCore
  module Representations
    include ThinRest::Representations
  end
end

require "#{dir}/representations/spec.html"
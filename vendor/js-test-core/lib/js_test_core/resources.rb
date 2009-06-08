dir = File.dirname(__FILE__)

module JsTestCore
  module Resources
  end
end

require "#{dir}/resources/resource"
require "#{dir}/resources/selenium_session"
require "#{dir}/resources/file"
require "#{dir}/resources/spec_file"
require "#{dir}/resources/core_file"
require "#{dir}/resources/web_root"
require "#{dir}/resources/not_found"

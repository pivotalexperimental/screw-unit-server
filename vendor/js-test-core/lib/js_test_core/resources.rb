dir = File.dirname(__FILE__)

module JsTestCore
  module Resources
  end
end

require "#{dir}/resources/resource"
require "#{dir}/resources/runner"
require "#{dir}/resources/file"
require "#{dir}/resources/spec_file"
require "#{dir}/resources/core_file"
require "#{dir}/resources/web_root"
require "#{dir}/resources/session"
require "#{dir}/resources/session_finish"
require "#{dir}/resources/not_found"

dir = File.dirname(__FILE__)

module JsTestCore
  module Resources
    include ThinRest::Resources
  end
end

require "#{dir}/resources/runner"
require "#{dir}/resources/file"
require "#{dir}/resources/dir"
require "#{dir}/resources/specs/spec"
require "#{dir}/resources/specs/spec_file"
require "#{dir}/resources/specs/spec_dir"
require "#{dir}/resources/web_root"
require "#{dir}/resources/session"
require "#{dir}/resources/session_finish"

puts "#{__FILE__}:#{__LINE__}"
dir = File.dirname(__FILE__)
require "#{dir}/lib/screw_unit"
require "sinatra"
ScrewUnit.spec_root_path = ENV["SPEC_ROOT_PATH"] || File.expand_path("./spec/javascripts")
ScrewUnit.public_path = ENV["PUBLIC_PATH"] || File.expand_path("./public")
use ScrewUnit::App
run Sinatra::Application

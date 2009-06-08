dir = File.dirname(__FILE__)
require "#{dir}/lib/screw_unit"
require "sinatra"

ScrewUnit.spec_root_path = ENV["SCREW_UNIT_SPEC_ROOT"] || File.expand_path("./spec/javascripts")
if File.directory?(ScrewUnit.spec_root_path)
  puts "SCREW_UNIT_SPEC_ROOT is #{ScrewUnit.spec_root_path}"
else
  raise "SCREW_UNIT_SPEC_ROOT #{ScrewUnit.spec_root_path} must be a directory"
end

ScrewUnit.public_path = ENV["SCREW_UNIT_PUBLIC"] || File.expand_path("./public")
if File.directory?(ScrewUnit.public_path)
  puts "SCREW_UNIT_PUBLIC is #{ScrewUnit.public_path}"
else
  raise "SCREW_UNIT_PUBLIC #{ScrewUnit.public_path} must be a directory"
end

use ScrewUnit::App
run Sinatra::Application

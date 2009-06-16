dir = File.dirname(__FILE__)
require "#{dir}/lib/screw_unit"
ScrewUnit::Server.standalone_rackup(self, ENV["SCREW_UNIT_SPEC_ROOT"], ENV["SCREW_UNIT_PUBLIC"])
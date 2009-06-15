dir = File.dirname(__FILE__)
require "#{dir}/lib/screw_unit"
ScrewUnit::Server.standalone_rackup(self)
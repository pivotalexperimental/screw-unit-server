require "rubygems"
require "thin"
require "erector"

dir = File.dirname(__FILE__)
require "#{dir}/thin_rest/connection"
require "#{dir}/thin_rest/resources"
require "#{dir}/thin_rest/representations"
require "#{dir}/thin_rest/routing_error"
require "#{dir}/thin_rest/extensions"

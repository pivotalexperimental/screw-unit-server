dir = File.dirname(__FILE__)
raise "Failure" unless system(%Q|ruby #{dir}/unit_suite.rb|)

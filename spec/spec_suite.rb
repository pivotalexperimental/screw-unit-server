dir = File.dirname(__FILE__)
raise "Failure" unless system(%Q|ruby #{dir}/unit_suite.rb|)
#raise "Failure" unless system(%Q|ruby #{dir}/functional_suite.rb|)
#raise "Failure" unless system(%Q|ruby #{dir}/integration_suite.rb|)

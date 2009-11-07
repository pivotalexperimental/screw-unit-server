dir = File.dirname(__FILE__)
raise "Failure" unless system(%Q|ruby #{dir}/functional_suite.rb|)

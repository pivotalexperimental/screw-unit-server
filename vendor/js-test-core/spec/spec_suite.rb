dir = File.dirname(__FILE__)
raise "Unit Suite Failure" unless system(%Q|ruby #{dir}/unit_suite.rb|)
raise "Functional Suite Failure" unless system(%Q|ruby #{dir}/functional_suite.rb|)

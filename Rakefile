begin
  require 'jeweler'
  Jeweler::Tasks.new do |s|
    s.name = "screw-unit"
    s.executables = ["screw_unit", "screw_unit_server"]
    s.summary = "Server and helpers for your Screw Unit tests."
    s.email = "pivotallabsopensource@googlegroups.com"
    s.homepage = "http://github.com/pivotal/screw-unit-server"
    s.description = "The Screw Unit server conveniently serves your Screw Unit specs and implementations javascript files and css stylesheets."
    s.authors = ["Pivotal Labs", "Brian Takita"]
    s.files = Dir["[A-Z]*"] +
      Dir["*.rb"] +
      Dir["lib/**/*.rb"] +
      Dir["core/**/**"] +
      Dir["bin/**"] +
      Dir["vendor/**/**"] +
      Dir["spec/**"]
    s.test_files = Dir['spec/**/*.rb']
    s.rdoc_options = ["--main", "README.markdown"]
    s.extra_rdoc_files = ["README.markdown", "CHANGES"]
  end
rescue LoadError
  puts "Jeweler, or one of its dependencies, is not available. Install it with: sudo gem install technicalpickles-jeweler -s http://gems.github.com"
end

desc "Runs the Rspec suite"
task(:default) do
  run_suite
end

desc "Runs the Rspec suite"
task(:spec) do
  run_suite
end

def run_suite
  dir = File.dirname(__FILE__)
  system("ruby #{dir}/spec/spec_suite.rb") || raise("Example Suite failed")
end

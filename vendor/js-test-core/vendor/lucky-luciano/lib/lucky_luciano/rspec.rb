dir = File.dirname(__FILE__)
Dir["#{dir}/rspec/**/*.rb"].each do |file|
  require file
end
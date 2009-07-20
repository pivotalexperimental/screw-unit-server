Dir["#{File.dirname(__FILE__)}/frameworks/*.html.rb"].each do |file|
  require file
end

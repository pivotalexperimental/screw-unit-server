class UnitSuite
  def run
    dir = File.dirname(__FILE__)
    Dir["#{dir}/unit/**/*_spec.rb"].each do |file|
      require file
    end
  end
end

UnitSuite.new.run
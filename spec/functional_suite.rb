class FunctionalSuite
  def run
    dir = File.dirname(__FILE__)
    Dir["#{dir}/functional/**/*_spec.rb"].each do |file|
      require file
    end
  end
end

FunctionalSuite.new.run
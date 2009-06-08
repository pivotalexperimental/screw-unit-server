module ScrewUnit
  class ThinRunner
    def self.start
      Thin::Runner.new([
        "--port", "8080",
        "--rackup", File.expand_path("#{File.dirname(__FILE__)}/../../standalone.ru"),
        "start"]
      ).run!      
    end
  end
end
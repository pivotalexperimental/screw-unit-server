module ScrewUnit
  class Server
    def self.start
      require "thin"
      Thin::Runner.new([
        "--port", "8080",
        "--rackup", File.expand_path("#{File.dirname(__FILE__)}/../../standalone.ru"),
        "start"]
      ).run!      
    end
  end
end
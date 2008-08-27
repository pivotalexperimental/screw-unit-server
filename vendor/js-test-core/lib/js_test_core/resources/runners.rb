dir = File.dirname(__FILE__)

module JsTestCore
  module Resources
    class Runners < ThinRest::Resource
      route 'firefox' do |env, name|
        FirefoxRunner.new(env)
      end
    end
  end
end
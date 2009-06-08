class Spec::ExampleGroup
  class << self
    def macro(name, &block)
      eigen do
        define_method(name, &block)
      end
    end

    def eigen(&block)
      eigen_class = (class << self; self; end)
      eigen_class.class_eval(&block)
      eigen_class
    end
  end
  
  include Rack::Test::Methods
  include BeHttp
  attr_reader :core_path, :spec_root_path, :public_path, :server, :connection
  before(:all) do
    dir = File.dirname(__FILE__)
    @core_path = File.expand_path("#{LIBRARY_ROOT_DIR}/spec/example_core")
    @spec_root_path = File.expand_path("#{LIBRARY_ROOT_DIR}/spec/example_specs")
    @public_path = File.expand_path("#{LIBRARY_ROOT_DIR}/spec/example_public")
    stub(Thread).start.yields
  end

  before(:each) do
    JsTestCore::Configuration.instance.spec_root_path = spec_root_path
    JsTestCore::Configuration.instance.public_path = public_path
    JsTestCore::Configuration.instance.core_path = core_path
  end

  def app
    Sinatra::Application
  end
end

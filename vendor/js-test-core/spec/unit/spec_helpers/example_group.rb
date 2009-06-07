class Spec::ExampleGroup
  include Rack::Test::Methods
  attr_reader :core_path, :spec_root_path, :implementation_root_path, :public_path, :server, :connection
  before(:all) do
    dir = File.dirname(__FILE__)
    @core_path = File.expand_path("#{LIBRARY_ROOT_DIR}/spec/example_core")
    @spec_root_path = File.expand_path("#{LIBRARY_ROOT_DIR}/spec/example_specs")
    @implementation_root_path = File.expand_path("#{LIBRARY_ROOT_DIR}/spec/example_public/javascripts")
    @public_path = File.expand_path("#{LIBRARY_ROOT_DIR}/spec/example_public")
    stub(Thread).start.yields
  end

  before(:each) do
    JsTestCore::Configuration.instance = JsTestCore::Configuration.new(
      :spec_root_path => spec_root_path,
      :implementation_root_path => implementation_root_path,
      :public_path => public_path,
      :core_path => core_path
    )
  end

  def app
    Sinatra::Application
  end

  def be_http(status, headers, body)
    SimpleMatcher.new(nil) do |given, matcher|
      description = (<<-DESC).gsub(/^ +/, "")
      be an http of
      expected status: #{status.inspect}
      actual status  : #{given.status.inspect}

      expected headers containing: #{headers.inspect}
      actual headers             : #{given.headers.inspect}

      expected body containing: #{body.inspect}
      actual body             : #{given.body.inspect}
      DESC
      matcher.failure_message = description
      matcher.negative_failure_message = "not #{description}"

      passed = true
      unless given.status == status
        passed = false
      end
      unless headers.all?{|k, v| given.headers[k] == headers[k]}
        passed = false
      end
      unless body.is_a?(Regexp) ? given.body =~ body : given.body.include?(body)
        passed = false
      end
      passed
    end
  end
end

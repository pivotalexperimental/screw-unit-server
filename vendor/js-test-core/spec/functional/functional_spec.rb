require File.expand_path("#{File.dirname(__FILE__)}/functional_spec_helper")

describe JsTestCore do
  attr_reader :stdout, :request
  before do
    @stdout = StringIO.new
    JsTestCore::Client.const_set(:STDOUT, stdout)
    @request = "http request"
  end

  after do
    JsTestCore::Client.__send__(:remove_const, :STDOUT)
  end

  it "runs a full passing Suite" do
    JsTestCore::Client.run(:spec_url => "#{root_url}/specs/foo/passing_spec")
    stdout.string.strip.should == JsTestCore::Client::PASSED_RUNNER_STATE.capitalize
  end

  it "runs a full failing Suite" do
    JsTestCore::Client.run(:spec_url => "#{root_url}/specs/foo/failing_spec")
    stdout.string.strip.should include(JsTestCore::Client::FAILED_RUNNER_STATE.capitalize)
    stdout.string.strip.should include("A failing spec in foo fails: expected true to equal false")
  end
end

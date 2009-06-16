require File.expand_path("#{File.dirname(__FILE__)}/functional_spec_helper")

describe ScrewUnit do
  attr_reader :stdout, :request
  before do
    @stdout = StringIO.new
    ScrewUnit::Client.const_set(:STDOUT, stdout)
    @request = "http request"
  end

  after do
    ScrewUnit::Client.__send__(:remove_const, :STDOUT)
  end

  it "runs a full passing Suite" do
    ScrewUnit::Client.run(:spec_url => "#{root_url}/specs/foo/passing_spec")
    stdout.string.strip.should == "SUCCESS"
  end

  it "runs a full failing Suite" do
    ScrewUnit::Client.run(:spec_url => "#{root_url}/specs/foo/failing_spec")
    stdout.string.strip.should include("FAILURE")
    stdout.string.strip.should include("A failing spec in foo fails: expected true to equal false")
  end
end

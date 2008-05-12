require File.expand_path("#{File.dirname(__FILE__)}/functional_spec_helper")

describe "ScrewUnit" do
  it "runs a full passing Suite" do
    mock(ScrewUnit::Client).puts("SUCCESS")
    ScrewUnit::Client.run(:spec_url => "#{root_url}/specs/foo/passing_spec")
  end

  it "runs a full failing Suite" do
    mock(ScrewUnit::Client).puts("FAILURE")
    mock(ScrewUnit::Client).puts('expected true to equal false')
    ScrewUnit::Client.run(:spec_url => "#{root_url}/specs/foo/failing_spec")
  end
end

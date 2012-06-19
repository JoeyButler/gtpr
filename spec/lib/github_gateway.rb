require 'spec_helper_lite'
require 'github/gateway'
require 'vcr'
require 'faraday'

VCR.configure do |c|
  c.cassette_library_dir = 'fixtures/vcr_cassettes'
  c.hook_into :faraday
end

describe Github::Gateway do
  it "should return a list of repos" do
    VCR.use_cassette('github') do
      
    end
    Github::Gateway.find_repos_for_user('joeyb')
  end
end

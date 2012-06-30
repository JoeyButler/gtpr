require 'spec_helper_lite'
require 'github/gateway/client'
require 'vcr'
require 'faraday_middleware'

VCR.configure do |c|
  c.cassette_library_dir = 'fixtures/vcr_cassettes'
  c.hook_into :faraday
end

describe Github::Gateway::Client do
  subject do
    # Use Oauth for joeybutler, since we need an example that belongs to orgs
    cache_stub = Object.new.tap {|obj| def obj.fetch(key, &blk); blk.call; end }
    Github::Gateway::Client.new('2e46787bafcfac21260301ce8997b387c4e91512', cache_stub)
  end

  it "should return a list of orgs that the user belongs to" do
    VCR.use_cassette('github') do
      orgs = subject.find_organizations_for_user('joeybutler')
      org = orgs.first
      org.should be_kind_of Github::Gateway::Client::Organization
      org.login.should eql('livingsocial')
    end
  end

  it "should return a list of repos by orgs that the user belongs to" do
    VCR.use_cassette('github_orgs') do
      repos = subject.find_repos_for_user_across_organizations('joeybutler')
      repo = repos.first
      repo.should be_kind_of Github::Gateway::Client::Repo
      repos.any?(&:private).should be_true
    end
  end
end

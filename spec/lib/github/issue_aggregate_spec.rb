require 'spec_helper_lite'
require 'github/gateway'
require 'github/gateway/client'
require 'github/issue_aggregate'

describe Github::IssueAggregate do
  describe "#all_pulls_across_all_repos_for_user" do
    it "should return the pulls nested to the corresponding repo" do
      username = 'joeyb'
      full_name = 'joeyb/my_repo'
      pr_title = 'refactor all the things'
      pr_finder = mock.tap do |mock|
        mock.should_receive(:find_repos_for_user).with(username).and_return(
          [Github::Gateway::Client::Repo.new(full_name: full_name)])
        mock.should_receive(:find_pulls_for_repo).with(full_name).and_return(
          [Github::Gateway::Client::PullRequest.new(title: pr_title)])
      end

      subject = Github::IssueAggregate.new(pr_finder)
      repos = subject.for_user(username)

      repos.size.should equal 1
      my_repo = repos.first
      my_repo.should be_kind_of(Github::Gateway::Client::Repo)
      my_repo.full_name.should equal full_name
      my_repo.pulls.first.title.should equal pr_title
    end
  end
end

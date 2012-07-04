class ReposController < ApplicationController
  def index
    aggregate = Github::IssueAggregate.new(@gh_client)
    @repos = aggregate.for_user 'mattmueller'#(current_user.name)
    # Do we need to show repos without any issues?
    # @repos.reject! {|r| r.open_issues.zero? }
    @repos.reject! {|r| r.private }
    @repos.sort! {|a,b| b.open_issues <=> a.open_issues }
  end
end

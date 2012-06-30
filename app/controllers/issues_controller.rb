class IssuesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :instantiate_github_client

  def index
    aggregate = Github::IssueAggregate.new(@gh_client)
    debugger
    @repos = aggregate.for_user(current_user.name)
  end

  def instantiate_github_client
    @gh_client = Github::Gateway::Client.new(current_user.token)
  end
end

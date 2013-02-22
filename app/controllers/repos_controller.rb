class ReposController < ApplicationController
  def index
    aggregate = Github::IssueAggregate.new(@gh_client)
    username = params.fetch(:username, current_user.name)
    @repos = aggregate.for_user(username)
    # Do we need to show repos without any issues?
    # @repos.reject! {|r| r.open_issues.zero? }
    @repos.reject! {|r| r.private }
    @repos.sort! {|a,b| b.open_issues <=> a.open_issues }
  rescue Github::Gateway::Client::NotFoundError
    flash[:error] = "Cannot find user [#{params[:username]}]."
    @repos = []
  end
end

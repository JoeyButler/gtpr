class IssuesController < ApplicationController
  # GET /repos/:repo/issues
  # param full repo name
  def index
    @issues = @gh_client.find_issues_for_repo(params[:repo_id])
    @issues.sort_by! {|i| i.pull_request_url.to_i}
    render json: {issues: @issues}
  end
end

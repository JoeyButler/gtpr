class IssuesController < ApplicationController
  # get /repos/:repo/issues
  def show
    @issues = @gh_client.find_pulls_for_repo(params[:id])
    render json: @issues
  end
end

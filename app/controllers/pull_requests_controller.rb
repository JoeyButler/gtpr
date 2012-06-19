class PullRequestsController < ApplicationController
  def index
    aggregate = Github::PullRequestAggregate.new
    render json: aggregate.all_pulls_across_all_repos_for_user('mattmueller')
  end
end

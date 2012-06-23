class IssuesController < ApplicationController
  def index
    aggregate = Github::PullRequestAggregate.new
    @repos = aggregate.all_pulls_across_all_repos_for_user('defunkt')
  end
end

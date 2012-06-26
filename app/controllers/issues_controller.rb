class IssuesController < ApplicationController
  def index
    aggregate = Github::IssueAggregate.new
    @repos = aggregate.for_user('defunkt')
  end
end

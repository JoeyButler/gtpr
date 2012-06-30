class ApplicationController < ActionController::Base
  protect_from_forgery
  helper :all

  before_filter :authenticate_user!
  before_filter :instantiate_github_client

  def instantiate_github_client
    @gh_client = Github::Gateway::Client.new(current_user.token)
  end
end

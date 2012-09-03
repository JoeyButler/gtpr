class ApplicationController < ActionController::Base
  protect_from_forgery
  helper :all

  before_filter :authenticate_user!
  before_filter :instantiate_github_client, except: :sign_in

  def instantiate_github_client
    # HACK: devise abtracts a little too much
    if current_user.present?
      @gh_client = Github::Gateway::Client.new(current_user.token)
    end
  end
end

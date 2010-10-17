class UserSessionsController < ApplicationController
  before_filter :require_user, :only => :destroy
  
  def destroy
    current_user_session.destroy
    redirect_to root_path
  end
end

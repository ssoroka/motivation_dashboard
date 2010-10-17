class UserSessionsController < ApplicationController
  before_filter :require_user, :only => :destroy
  
  def destroy
    current_user_session.destroy
    flash[:notice] = "You have been logged out."
    redirect_to root_path
  end
end

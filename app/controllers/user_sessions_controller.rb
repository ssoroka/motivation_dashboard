class UserSessionsController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => :destroy
  
  def destroy
    current_user_session.destroy
    redirect_back_or_default root_path
  end
end

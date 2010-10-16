class UsersController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => [:show, :edit, :update]
  
  def create
    @user = User.new_user_session_or_new_user(params[:user])
    
    if @user.save
      redirect_to dashboards_path
    else
      render :action => 'pages/home'
    end
  end
  
  def show
    @user = current_user
  end

  def edit
    @user = current_user
  end
  
  def update
    @user = current_user
    if @user.update_attributes(params[:user])
      redirect_to dashboards_path
    else
      render :action => :edit
    end
  end
end

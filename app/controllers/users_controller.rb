class UsersController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => [:show, :edit, :update]
  
  # Currently we're using this action for the front-end login & registration. - Nathan Fri 8:33pm
  def create
    @user = User.new(params[:user])
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

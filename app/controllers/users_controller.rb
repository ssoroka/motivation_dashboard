class UsersController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => [:show, :edit, :update]
  layout 'dashboard', :except => [:create]
  
  def create
    @user = User.new_user_session_or_new_user(params[:user])
    
    if @user.save
      redirect_to dashboard_path
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
    params[:user][:password], params[:user][:password_confirmation] = nil, nil unless params[:change_password]
    @user = current_user
    if @user.update_attributes(params[:user])
      redirect_to user_path(@user)
    else
      render :action => :edit
    end
  end
end

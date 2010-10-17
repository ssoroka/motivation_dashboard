class UsersController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => [:show, :edit, :update]
  layout :determine_layout

  def create
    @user = User.new_user_session_or_new_user(params[:user] || params[:user_session])
    
    if @user.save
      redirect_to dashboard_path
    else
      @subscriber = Subscriber.new
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
  
  def reset_api_key
    current_user.api_key = SecureRandom.hex(20)
    if current_user.save
      flash[:notice] = "Your API Key has been reset to " + current_user.api_key
    else
      flash[:error] = "Could not update your API Key at this time."
    end
    redirect_to user_path(current_user)
  end
  
  private
  
  # Apparently, you can't specify layout multiple times :-( Nathan 12:49AM SAT
  def determine_layout
    action_name == 'create' ? 'application' : 'dashboard'
  end  
end

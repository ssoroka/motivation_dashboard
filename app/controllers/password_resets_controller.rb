class PasswordResetsController < ApplicationController
  before_filter :require_no_user
  skip_before_filter :require_user
  before_filter :load_user_using_perishable_token, :only => [:edit, :update]
  
  def new
  end
  
  def create
    # TODO - Change the flash messages? They are a bit FUGLY lookin' - Nathan 1:21AM SAT
    if User.find_by_email_and_send_reset_instructions(params[:email])
      flash.now[:notice] = "Instructions to reset your password have been emailed to #{params[:email]}."
      params[:email] = nil
      render :action => :new
    else
      flash[:notice] = "Hmm.. Looks like no user was found with that email address."
      render :action => :new
    end
  end
  
  def edit
  end

  def update    
    @user.password = params[:user][:password]
    @user.password_confirmation = params[:user][:password_confirmation]
    
    if !params[:user][:password].blank? && @user.save
      @user_session = UserSession.new(@user)
      if @user_session.save
        redirect_to dashboard_path
      else
        flash[:notice] = "Your password has been reset. Please login."
        redirect_to root_path
      end
    else
      render :action => :edit
    end
  end

  private

  def load_user_using_perishable_token
    @user = User.find_by_perishable_token(params[:perishable_token])
    unless @user
      flash[:notice] = "We're sorry, but we could not locate your account. Try copying and pasting the URL from the email we sent your or try reseting your password again."
    end
  end
  
end
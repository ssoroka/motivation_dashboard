class ApplicationController < ActionController::Base
  protect_from_forgery
  
  helper :all
  helper_method :current_user_session, :current_user
  before_filter :login_from_api_key
  
  private

  def login_from_api_key
    
    if params[:api_key]
      if @current_user = User.find_by_api_key(params[:api_key])
        @user_session = UserSession.new(@current_user) 
        @current_user_session = UserSession.find
      end
    end
  end
  
  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end
  
  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.record
  end
  
  def logged_in?
    current_user
  end

  def require_user
    unless logged_in?
      store_location
      flash.now[:notice] = "You must be logged in to access this page"
      redirect_to root_path
      return false
    end
  end

  def require_no_user
    if logged_in?
      store_location
      flash.now[:notice] = "You must be logged out to access this page"
      redirect_to root_path
      return false
    end
  end
  
  def store_location
    session[:return_to] = request.fullpath
  end
  
  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end
end

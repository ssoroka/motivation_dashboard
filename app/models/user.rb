class User < ActiveRecord::Base
  acts_as_authentic
  
  def full_name
    "#{first_name} #{last_name}"
  end

  def self.new_user_session_or_new_user(params)
    existing_user = self.find_by_email(params[:email])
    
    if existing_user
      user_session = UserSession.new(params[:user_session])
    else
      params[:password_confirmation] = params[:password]
      self.new(params)
    end
  end
  
end

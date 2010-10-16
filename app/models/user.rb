class User < ActiveRecord::Base
  acts_as_authentic
  
  has_one :dashboard

  def full_name
    "#{first_name} #{last_name}"
  end
  
  # Ugh, I hate this naming - Nathan 12:07AM SAT
  def user_bar_name
    full_name.blank? ? email : full_name
  end
  

  def self.new_user_session_or_new_user(params)
    existing_user = self.find_by_email(params[:email])
    
    if existing_user
      user_session = UserSession.new(params)
    else
      params[:password_confirmation] = params[:password]
      self.new(params)
    end
  end
  
end

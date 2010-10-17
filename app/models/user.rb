class User < ActiveRecord::Base
  acts_as_authentic 
  
  before_save :set_default_next_poll
  
  has_one :dashboard
  has_many :data_sources
  
  before_create :set_api_key

  def set_api_key
    self.api_key = SecureRandom.hex(20)
  end
  

  def full_name
    "#{first_name} #{last_name}"
  end
  
  # Ugh, I hate this naming - Nathan 12:07AM SAT
  def user_bar_name
    full_name.blank? ? email : full_name
  end
  
  def self.find_by_email_and_send_reset_instructions(email)
    user = self.find_by_email(email)
    UserMailer.password_reset_instructions(user).deliver if user
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
  
  def set_default_next_poll
    self.next_poll_at ||= 1.minute.from_now.utc
  end
  
  # punt the next_poll_at date to some time in the future.
  def punt_polling!
    if current_login_at > 5.minutes.ago.utc
      update_attribute(:next_poll_at, 30.seconds.from_now.utc)
    elsif current_login_at > 30.minutes.ago.utc
      update_attribute(:next_poll_at, 2.minutes.from_now.utc)
    else
      update_attribute(:next_poll_at, 5.minutes.from_now.utc)
    end
  end
end

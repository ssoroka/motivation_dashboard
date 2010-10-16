class UserMailer < ActionMailer::Base
  default :from => "noreply@motivationdashboard.com"
  
  def password_reset_instructions(user)
    @user = user
    mail(:to => user.email, :subject => "Motivation Dashboard - Password Reset Instructions")
  end
end

class PagesController < ApplicationController

  # Use this controller for the front-facing site? - Nathan 7:15pm
  def home
    @user = User.new
    @subscriber = Subscriber.new
  end
  
  def features
    
  end
  
  def pricing
    
  end
  
end
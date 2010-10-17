class PagesController < ApplicationController

  def home
    @user = User.new
    @subscriber = Subscriber.new(params[:subscriber])
    
    # Oh, this is so good looookin' :-) 
    if params[:subscriber]
      if @subscriber.save
        flash.now[:notice] = "Thanks for subscribing to our beta mailing list - we'll be sure to keep you posted!"
      else
        flash.now[:error] = "Hmm, that doesn't look like email addresss."
      end
    end
    
  end
  
  def features
    
  end
  
  def pricing
    
  end
  
end
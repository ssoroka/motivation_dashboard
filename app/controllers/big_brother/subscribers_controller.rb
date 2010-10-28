class BigBrother::SubscribersController < BigBrother::ApplicationController
    
  def index
    @subscribers = Subscriber.paginate(:per_page => 50, :page => params[:page], :order => 'email ASC')
  end
  
  def destroy
    @subscriber = Subscriber.find(params[:id])

    if @subscriber.destroy
      flash[:notice] = "Successfully removed #{@subscriber.email}"
    else
      flash[:error] = "Failed to remove for '#{@subscriber.email}'."
    end
    
    redirect_to [:big_brother, :subscribers]
  end
  

end
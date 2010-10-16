class Setup::WidgetsController < Setup::ApplicationController

  def new
    @widget = Widget.new
  end
  
  def create
    @widget = Widget.new(params[:widget])
    
    if @widget.save
      redirect_to dashboard_path
    else
      render :action => :new
    end    
  end

  def edit
    @widget = Widget.find(params[:id])
  end
  
  def update
    @widget = Widget.find(params[:id])
    
    if @widget.update_attributes(params[:widget])
      redirect_to dashboard_path
    else
      render :action => :edit
    end
  end

end
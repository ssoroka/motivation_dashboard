class Setup::WidgetsController < Setup::ApplicationController

  def new
    @widget = @report.widgets.build
  end
  
  def create
    @widget = @report.widgets.build(params[:widget])
    @widget.dashboard = current_user.dashboard
    
    if @widget.save
      redirect_to dashboard_path
    else
      render :action => :new
    end    
  end

  def edit
    @widget = @report.widgets.find(params[:id])
  end
  
  def update
    @widget = @report.widgets.find(params[:id])
    
    if @widget.update_attributes(params[:widget])
      redirect_to dashboard_path
    else
      render :action => :edit
    end
  end
end
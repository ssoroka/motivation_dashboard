class WidgetsController < ApplicationController
  respond_to :js, :html, :json
  
  def index
    respond_with do |wants|
      wants.html { redirect_to dashboard_path }
      wants.json { render :json => current_user.dashboard.widgets }
    end
  end

  def destroy
    @widget = current_user.dashboard.widgets.find(params[:id])
    @widget.destroy
    redirect_to dashboard_path
  end

end

class WidgetsController < ApplicationController

  def destroy
    @widget = current_user.dashboard.widgets.find(params[:id])
    @widget.destroy
    redirect_to dashboard_path
  end

end

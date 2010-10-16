class DashboardsController < ApplicationController
  before_filter :require_user
  
  # Use this controller for the front-facing site? - Nathan 7:15pm
  def show
    @dashboard = current_user.dashboard
  end

end
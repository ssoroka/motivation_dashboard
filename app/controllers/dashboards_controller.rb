class DashboardsController < ApplicationController
  before_filter :require_user
  layout 'dashboard'
  
  # Use this controller for the front-facing site? - Nathan 7:15pm
  def show
    @dashboard = current_user.dashboard || current_user.create_dashboard
  end

end
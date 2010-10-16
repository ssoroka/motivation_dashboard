class DashboardsController < ApplicationController
  before_filter :require_user
  layout 'dashboard'
  
  def show
    @dashboard = current_user.dashboard || current_user.create_dashboard
  end

end
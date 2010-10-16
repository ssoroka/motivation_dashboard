class WidgetsController < ApplicationController
  layout 'dashboard'

  def index
    # @data_sources = current_user.dashboard
    @data_source = DataSource.new
  end

end
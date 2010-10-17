class Setup::ApplicationController < ApplicationController
  layout 'dashboard'
  before_filter :require_user, :find_nested_resources
  respond_to :js, :html, :json
  
  def find_nested_resources
    @data_source = current_user.data_sources.find(params[:data_source_id]) if params[:data_source_id]
    @data_set = @data_source.data_sets.find(params[:data_set_id]) if params[:data_set_id]
    @report = @data_set.reports.find(params[:report_id]) if params[:report_id]
  end
end
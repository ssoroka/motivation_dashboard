class Setup::ApplicationController < ApplicationController
  layout 'dashboard'
  before_filter :require_user, :find_nested_resources
  
  def find_nested_resources
    @data_source = DataSource.find(params[:data_source_id]) if params[:data_source_id]
    @data_set = DataSet.find(params[:data_set_id]) if params[:data_set_id]
  end
end
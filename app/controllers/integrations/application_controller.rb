class Integrations::ApplicationController < ApplicationController
  before_filter :find_data_source

  private

  def find_data_source
    @data_source = DataSource.find_by_api_key(params[:api_key])
    # TODO - Render something if the API_KEY is invalid... Like "Invalid API-KEY"
  end

end
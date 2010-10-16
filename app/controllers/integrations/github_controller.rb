class Integrations::GithubController < Integrations::ApplicationController
  skip_before_filter :verify_authenticity_token
  
  # /integrations/github/post_receive_hook?api_key=
  def post_receive_hook
    render :text => '', :status => 200
  end
  
end
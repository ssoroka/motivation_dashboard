class BigBrother::ApplicationController < ApplicationController
  before_filter :check_current_is_admin
  layout 'admin'

  private

  def check_current_is_admin
    if current_user
      redirect_to dashboard_path unless current_user.is_admin?
    else
      redirect_to root_path
    end
  end

end
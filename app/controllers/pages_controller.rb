class PagesController < ApplicationController

  # Use this controller for the front-facing site? - Nathan 7:15pm
  def home
    @user = User.new
  end

end
class HomeController < ApplicationController
  def index
    redirect_to dashboard_index_path and return if current_user
  end

  def profile
  end
end

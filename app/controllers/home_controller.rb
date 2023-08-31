class HomeController < ApplicationController
  skip_before_action :authenticate_user!
  def index
    redirect_to dashboard_index_path and return if current_user
  end
end

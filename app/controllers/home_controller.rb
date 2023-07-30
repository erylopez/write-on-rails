class HomeController < ApplicationController
  def index
    redirect_to onboarding_index_path and return if current_user && current_user.onboarding_step != "step_4"
  end
end

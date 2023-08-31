class HomeController < ApplicationController
  skip_before_action :authenticate_user!
  def index
    redirect_to onboarding_index_path and return if current_user && current_user.onboarding_step != "step_4"
    redirect_to dashboard_index_path and return if current_user && current_user.onboarding_step == "step_4"
  end

  def login
  end

  def onboarding_step1
  end

  def onboarding_step2
  end

  def onboarding_step3
  end

  def onboarding_step4
  end
end

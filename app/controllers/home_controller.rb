class HomeController < ApplicationController
  def index
    redirect_to onboarding_index_path and return if current_user && current_user.onboarding_step != "step_4"
    redirect_to dashboard_index_path and return if current_user && current_user.onboarding_step == "step_4"
  end

  def login
  end

  def profile
  end

  def onboarding_step1
  end

  def onboarding_step2
  end

  def onboarding_step3
  end

  def onboarding_step4
  end

  def post1
  end

  def dashboard
  end
end

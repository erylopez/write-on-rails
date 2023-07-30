class OnboardingController < ApplicationController
  def index
    redirect_to_current_step and return
  end

  def step_1
    redirect_to_current_step and return if !current_user.step_1?
  end
  
  def step_2
    redirect_to_current_step and return if !current_user.step_2?
  end

  def step_3
    redirect_to_current_step and return if !current_user.step_3?
  end

  def complete_step_1
    current_user.complete_step_1
    redirect_to_current_step
  end

  def complete_step_2
    current_user.complete_step_2
    redirect_to_current_step
  end

  def complete_step_3
    if update_publishing_platforms
      current_user.complete_step_3
      redirect_to notion_sync_pages_path
    else
      render :step_3
    end
  end

  def previous_step
    current_user.previous_step
    redirect_to_current_step
  end

  def reset
    current_user.reset_onboarding
    redirect_to_current_step
  end

  def notion_fetch_page
    client = Notion::Client.new(token: current_user.notion_access_token)
    databases = client.search(filter: { property: 'object', value: 'database' })

    pages = []
    client.database_query(database_id: databases.results.first.id) do |results_page|
      results_page.results.each { |page| pages << page.properties["Name"].title.first.plain_text }
    end
    
    render turbo_stream: turbo_stream.replace(:pages, partial: "onboarding/pages", locals: { pages: pages })
  end

  private

  def update_publishing_platforms
    if params[:user] && (params[:user][:hashnode_access_token].present? || params[:user][:devto_api_key].present?)
      current_user.update(params.require(:user).permit(:hashnode_access_token, :devto_api_key))
    else
      true
    end
  end

  def redirect_to_current_step
    case current_user.reload.onboarding_step
    when 'step_1'
      redirect_to step_1_onboarding_index_path and return
    when 'step_2'
      redirect_to step_2_onboarding_index_path and return
    when 'step_3'
      redirect_to step_3_onboarding_index_path and return
    when 'step_4'
      redirect_to dashboard_index_path and return
    end
  end
end

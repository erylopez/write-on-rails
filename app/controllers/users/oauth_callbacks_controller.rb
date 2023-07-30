# Purpose: Controller for handling OAuth callbacks. Different from OmniAuth callbacks, which are handled by Devise for authentication purposes.
class Users::OauthCallbacksController < ApplicationController
  def notion
    response = Notion::GetAuthorizationToken.new(code: params[:code], redirect_uri: users_auth_notion_callback_url).call
    current_user.update(notion_access_token: response["access_token"], notion_page_id: response["duplicated_template_id"])
    current_user.complete_step_1
    redirect_to onboarding_index_path, notice: "Notion integration successful!"
  end
end

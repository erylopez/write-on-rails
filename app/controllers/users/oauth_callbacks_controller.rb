# Purpose: Controller for handling OAuth callbacks. Different from OmniAuth callbacks, which are handled by Devise for authentication purposes.
class Users::OauthCallbacksController < ApplicationController
  def notion
    render json: Notion::GetAuthorizationToken.new(code: params[:code], redirect_uri: users_auth_notion_callback_url).call
  end
end

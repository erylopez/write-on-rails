module ApplicationHelper
  def user_signed_in?
    true
  end

  def notion_oauth_url
    redirect_url = CGI.escape(users_auth_notion_callback_url)
    "https://api.notion.com/v1/oauth/authorize?client_id=#{Rails.application.credentials.notion[:client_id]}&response_type=code&owner=user&redirect_uri=#{redirect_url}"
  end
end

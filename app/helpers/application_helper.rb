module ApplicationHelper
  def notion_oauth_url
    redirect_url = CGI.escape(users_auth_notion_callback_url)
    "https://api.notion.com/v1/oauth/authorize?client_id=#{Rails.application.credentials.notion[:client_id]}&response_type=code&owner=user&redirect_uri=#{redirect_url}"
  end

  def test
    current_user.attributes_from_keys(:dev_to_api_key, :hashnode_access_token)
  end

  def render_badge(text:, color:)
    tailwind_classes = "bg-#{color}-200/50 text-#{color}-700 text-sm font-medium inline-flex items-center px-2.5 py-0.5 rounded dark:bg-#{color}-700/50 dark:text-#{color}-200 border border-#{color}-400"
    "<span class='#{tailwind_classes}'>#{text}</span>".html_safe
  end
end

class Notion::GetAuthorizationToken
  def initialize(code:, redirect_uri:)
    @code = code
    @redirect_uri = redirect_uri
  end

  def call
    basic_auth = { username: Rails.application.credentials.notion[:client_id], password: Rails.application.credentials.notion[:client_secret] }
    body = { grant_type: "authorization_code", code: @code, redirect_uri: @redirect_uri }
    HTTParty.post("https://api.notion.com/v1/oauth/token", basic_auth: basic_auth, body: body)
  end
end

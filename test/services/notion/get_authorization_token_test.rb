require "test_helper"

class Notion::GetAuthorizationTokenTest < ActiveSupport::TestCase
  test "should get an authorization token" do
    VCR.use_cassette("notion/get_authorization_token") do
      response = Notion::GetAuthorizationToken.new(
        code: "code",
        redirect_uri: "http://localhost:3000/users/auth/notion/callback"
      ).call
      assert_equal HTTParty::Response, response.class
      assert response.dig("access_token").present?
      assert response.dig("duplicated_template_id").present?
    end
  end
end

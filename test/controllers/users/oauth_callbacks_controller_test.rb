require "test_helper"

class Users::OauthCallbacksControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    user = users(:empty)
    sign_in user

    VCR.use_cassette("notion/get_authorization_token") do
      assert_changes -> { user.notion_access_token } do
        get "/users/auth/notion/callback", params: {code: "code"}
      end
    end

    assert_redirected_to onboarding_index_path
  end
end

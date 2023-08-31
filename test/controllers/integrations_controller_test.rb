require "test_helper"

class IntegrationsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:two)
    sign_in @user
  end

  test "saves hashnode integration" do
    post integrations_path, params: {user: {hashnode_access_token: "12345", hashnode_username: "username"}}

    assert_equal @user.hashnode_access_token, "12345"
    assert_equal @user.hashnode_username, "username"
  end

  test "saves devto integration" do
    post integrations_path, params: {user: {devto_api_key: "123456"}}

    assert_equal @user.devto_api_key, "123456"
  end

  test "does not save integration if not logged in" do
    sign_out @user
    post integrations_path, params: {user: {devto_api_key: "123456"}}

    assert_response :redirect
    follow_redirect!
    assert_equal path, new_user_session_path
    assert_not_equal @user.devto_api_key, "123456"
  end
end

require "test_helper"

class OmniauthLoginTest < ActionDispatch::IntegrationTest
  test "can login with github using omniauth" do
    OmniAuth.config.mock_auth[:github] = auth_data
    get root_url
    assert_response :success

    assert_dom "form.button_to"
    omniauth_url = css_select("form.button_to").first.attribute("action").value

    assert_changes -> { User.count } do
      post omniauth_url
      assert_redirected_to user_github_omniauth_callback_url
      follow_redirect!
    end

    assert_redirected_to root_url
    follow_redirect!

    assert_redirected_to onboarding_index_url
    follow_redirect!

    assert_redirected_to step_1_onboarding_index_url
    follow_redirect!

    assert Capybara::Node::Simple.new(@response.body).assert_text "Where would you like to write your posts?"
  end

  test "wont create a new user if oauth fails" do
    OmniAuth.config.mock_auth[:github] = :invalid_credentials
    get root_url
    assert_response :success

    assert_dom "form.button_to"
    omniauth_url = css_select("form.button_to").first.attribute("action").value

    assert_no_changes -> { User.count } do
      post omniauth_url
      assert_redirected_to user_github_omniauth_callback_url
      follow_redirect!
    end

    assert_redirected_to root_url
    follow_redirect!

    assert Capybara::Node::Simple.new(@response.body).assert_text "Login with Github"
  end

  test "wont persist the user with invalid oauth data" do
    OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new({
      provider: "github",
      uid: nil,
      info: {email: "some@email.com"},
      credentials: {token: "randomtoken123456"}
    })
    get root_url
    assert_response :success

    assert_dom "form.button_to"
    omniauth_url = css_select("form.button_to").first.attribute("action").value

    assert_no_changes -> { User.count } do
      post omniauth_url
      assert_redirected_to user_github_omniauth_callback_url
      follow_redirect!
    end
    assert_redirected_to root_url
    follow_redirect!

    assert Capybara::Node::Simple.new(@response.body).assert_text "Could not sign in with GitHub"
  end
end

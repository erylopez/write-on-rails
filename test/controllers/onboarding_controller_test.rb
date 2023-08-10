require "test_helper"

class OnboardingControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    user = users(:one)
    sign_in user

    get onboarding_index_url
    assert_response :redirect
    follow_redirect!
    assert_equal "/onboarding/#{user.onboarding_step}", path
  end
end

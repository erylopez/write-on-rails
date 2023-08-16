require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "is onboardeable" do
    user = users(:onboarding_step_1)
    user.update(notion_page_id: nil)

    assert_equal user.onboarding_step, "step_1"

    assert user.complete_step_1
    assert_equal user.onboarding_step, "step_2"

    assert_not user.complete_step_2
    user.update(notion_page_id: "notion_page_id_123")
    assert user.complete_step_2

    assert_equal user.onboarding_step, "step_3"
    assert user.complete_step_3
    assert_equal user.onboarding_step, "step_4"
  end

  test "#devto_ready?" do
    empty_user = users(:empty)
    assert_not empty_user.devto_ready?
    user = users(:one)
    assert user.devto_ready?
  end
end

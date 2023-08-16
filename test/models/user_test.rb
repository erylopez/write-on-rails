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

  test "#get_hashnode_publication_id without hashnode integration" do
    user = users(:empty)
    assert_not user.get_hashnode_publication_id
  end

  test "#get_hashnode_publication_id with hashnode integration" do
    user = users(:one)
    Hashnode::GetPublications.any_instance.stubs(:call).returns({
      "data" => {"user" => {"publication" => {"_id" => "publication_id_123"}}}
    })

    assert_equal user.get_hashnode_publication_id, "publication_id_123"
  end

  test "#get_hashnode_publication_id handles http errors" do
    HTTParty.stubs(:post).raises(HTTParty::Error)
    user = users(:one)
    assert_not user.get_hashnode_publication_id
  end
end

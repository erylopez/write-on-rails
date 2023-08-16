require "test_helper"

class PostsControllerTest < ActionDispatch::IntegrationTest
  test "#index without a user session" do
    get posts_path
    assert_redirected_to new_user_session_path
  end

  test "#index with a valid user session" do
    sign_in users(:one)
    get posts_path
    assert_response :success
  end
end

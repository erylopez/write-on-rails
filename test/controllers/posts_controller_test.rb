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

  test "#destroy" do
    Devto::UpdatePublished.any_instance.stubs(:call).returns(true)
    user = users(:one)
    sign_in user
    post = user.posts.create(title: "Hello, World!", md_content: "This is a test post.", devto_id: 1)

    assert_difference("Post.count", -1) do
      delete post_path(post)
    end
  end
end

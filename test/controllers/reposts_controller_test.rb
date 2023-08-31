require "test_helper"

class RepostsControllerTest < ActionDispatch::IntegrationTest
  def setup
    Reposter::Hashnode.any_instance.stubs(:call).returns(true)
    Reposter::Devto.any_instance.stubs(:call).returns(true)
    @user = users(:one)
    sign_in @user
  end

  test "reposts to hashnode with correct params" do
    post = @user.posts.create(title: "A test from the controller", md_content: "#Testing\n This is a **test** from the controller")

    post reposts_path(params: {post_id: post.id, platform: "hashnode"})
    follow_redirect!

    assert Capybara::Node::Simple.new(@response.body).assert_text "Post has been reposted on hashnode"
  end

  test "wont repost to hashnode if the post is already reposted" do
    post = @user.posts.create(title: "A test from the controller", md_content: "test", hashnode_id: "someid")

    post reposts_path(params: {post_id: post.id, platform: "hashnode"})
    assert :unprocessable_entity
  end

  test "wont repost to hashnode if the user has not configured the integration yet" do
    user = users(:empty)
    sign_in user
    post = user.posts.create(title: "A test from the controller", md_content: "test")

    post reposts_path(params: {post_id: post.id, platform: "hashnode"})
    assert :unprocessable_entity
  end

  test "reposts to devto with correct params" do
    post = @user.posts.create(title: "A test from the controller", md_content: "#Testing\n This is a **test** from the controller")

    post reposts_path(params: {post_id: post.id, platform: "devto"})
    follow_redirect!
    assert_response :success
  end

  test "wont repost to devto if the post is already reposted" do
    post = @user.posts.create(title: "A test from the controller", md_content: "test", devto_id: "someid")

    post reposts_path(params: {post_id: post.id, platform: "devto"})
    assert :unprocessable_entity
  end

  test "wont repost to devto if the user has not configured the integration yet" do
    user = users(:empty)
    sign_in user
    post = user.posts.create(title: "A test from the controller", md_content: "test")

    post reposts_path(params: {post_id: post.id, platform: "devto"})
    assert :unprocessable_entity
  end
end

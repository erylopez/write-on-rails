require "test_helper"

class SyncPostsTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:one)
    sign_in @user
  end

  test "can navigate to dashboard page and find link for import posts from hashnode" do
    get "/"
    assert_redirected_to "/dashboard"
    follow_redirect!

    assert_response :success
    assert_dom "a[href=?]", "/sync_posts?platform=hashnode"

    VCR.use_cassette("hashnode/import_posts") do
      post "/sync_posts?platform=hashnode"
    end
    assert_redirected_to "/dashboard"
    follow_redirect!
    assert_response :success
  end

  test "can import posts from hashnode with valid data" do
    assert_changes -> { Post.count } do
      VCR.use_cassette("hashnode/import_posts") do
        post sync_posts_path(platform: "hashnode")
      end
    end

    assert_redirected_to "/dashboard"
    follow_redirect!
    assert_response :success
  end

  test "cannot import posts from hashnode without hashnode access token or hashnode username" do
    user = users(:empty)
    sign_in user

    post sync_posts_path(platform: "hashnode")
    assert_response :unprocessable_entity
  end

  test "can navitate to dashboard page and find link for import posts from devto" do
    get "/"
    assert_redirected_to "/dashboard"
    follow_redirect!

    assert_response :success
    assert_dom "a[href=?]", "/sync_posts?platform=devto"

    VCR.use_cassette("devto/sync_posts") do
      post "/sync_posts?platform=devto"
    end
    assert_redirected_to "/dashboard"
    follow_redirect!
    assert_response :success
  end

  test "can import posts from devto with valid data" do
    assert_changes -> { Post.count } do
      VCR.use_cassette("devto/sync_posts") do
        post sync_posts_path(platform: "devto")
      end
    end

    assert_redirected_to "/dashboard"
    follow_redirect!
    assert_response :success
  end

  test "cannot import posts from devto without devto api key" do
    user = users(:empty)
    sign_in user

    post sync_posts_path(platform: "devto")
    assert_response :unprocessable_entity
  end
end

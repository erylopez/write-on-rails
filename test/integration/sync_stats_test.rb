require "test_helper"

class SyncStatsTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:one)
    sign_in @user
  end

  test "can navigate to dashboard page and find link for sync stats from hashnode" do
    get "/"
    assert_redirected_to "/dashboard"
    follow_redirect!

    assert_response :success
    assert_dom "a[href=?]", "/sync_stats?platform=hashnode"

    VCR.use_cassette("hashnode/sync_stats") do
      post "/sync_stats?platform=hashnode"
    end
    assert_redirected_to "/dashboard"
    follow_redirect!
    assert_response :success
  end

  test "cannot sync stats from hashnode without hashnode access token or hashnode username" do
    user = users(:empty)
    sign_in user

    post sync_posts_path(platform: "hashnode")
    assert_response :unprocessable_entity
  end

  test "can navigate to dashboard page and find link for sync stats from devto" do
    get "/"
    assert_redirected_to "/dashboard"
    follow_redirect!

    assert_response :success
    assert_dom "a[href=?]", "/sync_stats?platform=devto"

    VCR.use_cassette("devto/sync_stats") do
      post "/sync_stats?platform=devto"
    end
    assert_redirected_to "/dashboard"
    follow_redirect!
    assert_response :success
  end

  test "cannot sync stats from devto without devto api key" do
    user = users(:empty)
    sign_in user

    post sync_stats_path(platform: "devto")
    assert_response :unprocessable_entity
  end
end

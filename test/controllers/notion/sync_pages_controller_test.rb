require "test_helper"

class Notion::SyncPagesControllerTest < ActionDispatch::IntegrationTest
  test "syncs notion pages" do
    user = users(:one)
    sign_in user
    VCR.use_cassette("notion/sync_pages_responses") do
      assert_changes -> { user.posts.count } do
        get "/notion/sync_pages"
      end
    end
  end
end

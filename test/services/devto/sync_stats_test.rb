require "test_helper"

class Devto::SyncStatsTest < ActiveSupport::TestCase
  test "syncs posts stats from devto to our db" do
    VCR.use_cassette("devto/sync_stats") do
      user  = users(:one)
      post  = user.posts.create(title: "from tests", md_content: "from tests", devto_id: 1554213)

      assert_changes -> { post.reload.devto_comments_count } do
        Devto::SyncStats.new(user: user).call
      end
    end
  end
end

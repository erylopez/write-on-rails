require "test_helper"

class Hashnode::SyncStatsTest < ActiveSupport::TestCase
  test "import posts" do
    user  = users(:one)
    post  = user.posts.create(title: "from tests", md_content: "from tests", hashnode_id: "64c5879a5a0f2b614f315cd6")

    VCR.use_cassette("hashnode/sync_stats") do
      assert_changes -> { post.reload.hashnode_views } do
        Hashnode::SyncStats.new(user:).call
      end
    end
  end
end

require "test_helper"

class Hashnode::SyncPostsTest < ActiveSupport::TestCase
  test "import posts" do
    user = users(:one)

    VCR.use_cassette("hashnode/sync_posts") do
      assert_changes "Post.count" do
        response = Hashnode::SyncPosts.new(user:).call
        assert_equal response.class, HTTParty::Response
        assert user.posts.last.hashnode_etag.present?
        assert user.posts.last.hashnode_url.present?
      end
    end
  end

  test "updates only posts that changed the etag" do
    user = users(:one)

    VCR.use_cassette("hashnode/sync_posts") do
      assert_changes "Post.count" do
        Hashnode::SyncPosts.new(user:).call
      end
    end

    last_post = user.posts.last
    last_post.update(hashnode_etag: "something-different")
    last_post_updated_at = last_post.updated_at
    first_post = user.posts.first
    first_post_updated_at = first_post.updated_at

    VCR.use_cassette("hashnode/sync_posts") do
      Hashnode::SyncPosts.new(user:).call
      assert_not_equal last_post_updated_at, last_post.reload.updated_at
      assert_equal first_post_updated_at.to_s, first_post.reload.updated_at.to_s
    end
  end
end

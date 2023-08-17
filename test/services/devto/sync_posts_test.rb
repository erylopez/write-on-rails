require "test_helper"

class Devto::SyncPostsTest < ActiveSupport::TestCase
  test "syncs posts to devto" do
    VCR.use_cassette("devto/sync_posts") do
      user = users(:one)

      assert_changes "Post.count" do
        response = Devto::SyncPosts.new(user: user).call
        assert_equal response.class, HTTParty::Response
        assert user.posts.last.devto_etag.present?
      end
    end
  end

  test "updates only posts that changed the etag" do
    user = users(:one)

    VCR.use_cassette("devto/sync_posts") do
      assert_changes "Post.count" do
        Devto::SyncPosts.new(user: user).call
      end
    end

    last_post = user.posts.last
    last_post.update(devto_etag: "something-different")
    last_post_updated_at = last_post.updated_at
    first_post = user.posts.first
    first_post_updated_at = first_post.updated_at

    VCR.use_cassette("devto/sync_posts") do
      Devto::SyncPosts.new(user: user).call
      assert_not_equal last_post_updated_at, last_post.reload.updated_at
      assert_equal first_post_updated_at, first_post.reload.updated_at
    end
  end
end

require "test_helper"

class Hashnode::SyncCommentsTest < ActiveSupport::TestCase
  test "import comments and replies" do
    user = users(:one)
    post = Post.create(user: user, title: "Testing comments", md_content: "This is a test post", hashnode_slug: "hello-world")

    VCR.use_cassette("hashnode/sync_comments_v2") do
      assert_changes "Comment.count" do
        response = Hashnode::SyncComments.new(post:).call
        assert_equal response.class, HTTParty::Response
        assert post.comments.any?
        assert Comment.where(parent_id: nil).first.comments.any?
        assert post.comments.last.author_name.present?
        assert post.comments.last.author_avatar.present?
        assert post.comments.last.published_at.present?
      end
    end
  end
end

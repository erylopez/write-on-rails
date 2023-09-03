require "test_helper"

class Hashnode::SyncCommentsTest < ActiveSupport::TestCase
  test "import comments and replies" do
    user = users(:one)
    post = Post.create(user: user, title: "Testing comments", md_content: "This is a test post", hashnode_slug: "hello-world")

    VCR.use_cassette("hashnode/sync_comments") do
      assert_changes "Comment.count" do
        response = Hashnode::SyncComments.new(post:).call
        assert_equal response.class, HTTParty::Response
        assert post.comments.any?
        assert Comment.where(parent_id: nil).first.comments.any?
      end
    end
  end
end

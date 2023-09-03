require "test_helper"

class Devto::SyncCommentsTest < ActiveSupport::TestCase
  test "import comments and replies" do
    user = users(:one)
    user.update(devto_api_key: "2Ghhnb6u349UgpFMa8zPPah1")
    post = Post.create(user: user, title: "Testing comments", md_content: "This is a test post", devto_id: "1554213")

    VCR.use_cassette("devto/sync_comments") do
      assert_changes "Comment.count" do
        response = Devto::SyncComments.new(post:).call
        assert_equal response.class, HTTParty::Response
        assert post.comments.any?
        assert Comment.where(parent_id: nil).first.comments.any?
      end
    end
  end
end

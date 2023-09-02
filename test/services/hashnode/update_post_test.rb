require "test_helper"

class Hashnode::UpdatePostTest < ActiveSupport::TestCase
  test "Updates post" do
    user = users(:one)
    post = user.posts.create(title: "Test", md_content: "Test", hashnode_id: "123456")

    VCR.use_cassette("hashnode/update_post") do
      response = Hashnode::UpdatePost.new(
        user: user,
        post: post
      ).call

      assert_equal response.class, HTTParty::Response
      assert_equal response.dig("data", "updateStory", "success"), true
      assert_equal response.dig("data", "updateStory", "post", "_id"), post.hashnode_id
    end
  end
end

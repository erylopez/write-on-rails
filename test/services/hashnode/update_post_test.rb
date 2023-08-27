require "test_helper"

class Hashnode::UpdatePostTest < ActiveSupport::TestCase
  test "updates post" do
    user = users(:one)
    post = user.posts.create(title: "Test", md_content: "Test", hashnode_id: "12345")

    VCR.use_cassette("hashnode/update_post") do
      response = Hashnode::UpdatePost.new(
        authorization_code: user.hashnode_access_token,
        publication_id: user.hashnode_publication_id,
        post: post
      ).call

      assert_equal response.class, HTTParty::Response
      assert_equal response.dig("data", "updateStory", "success"), true
      assert_equal response.dig("data", "updateStory", "post", "_id"), post.hashnode_id
    end
  end
end

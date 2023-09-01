require "test_helper"

class Hashnode::DeletePostTest < ActiveSupport::TestCase
  test "deletes a post in hashnode" do
    user = users(:one)
    VCR.use_cassette("hashnode/delete_post") do
      post = Post.create(title: "Created in tests", md_content: "Created **in** tests")

      response = Hashnode::CreatePost.new(
        authorization_code: "my-secret-authorization-code",
        publication_id: "my-publication-id",
        post: post
      ).call

      post.update(
        hashnode_id: response.dig("data", "createStory", "post", "_id"),
        hashnode_slug: response.dig("data", "createStory", "post", "slug")
      )

      assert_equal HTTParty::Response, response.class
      assert response.dig("data", "createStory", "post", "_id").present?

      delete_response = Hashnode::DeletePost.new(
        user: user,
        post: post
      ).call

      assert_equal HTTParty::Response, delete_response.class
      assert delete_response.dig("data", "deletePost", "success")
    end
  end
end

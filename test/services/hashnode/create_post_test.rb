require "test_helper"

class Hashnode::CreatePostTest < ActiveSupport::TestCase
  test "creates a post in hashnode" do
    VCR.use_cassette("hashnode/create_post") do
      post = posts(:one)
      response = Hashnode::CreatePost.new(
        authorization_code: "my-secret-authorization-code",
        publication_id: "64c578d95a0f2b614f315c59",
        post: post
      ).call
      assert_equal HTTParty::Response, response.class
      assert response.dig("data", "createStory", "post", "_id").present?
    end
  end

  test "wont create a post in hashnode with an invalid authorization code" do
    VCR.use_cassette("hashnode/create_post_error") do
      post = posts(:one)
      response = Hashnode::CreatePost.new(
        authorization_code: "invalid_code",
        publication_id: "64c578d95a0f2b614f315c59",
        post: post
      ).call
      assert_equal HTTParty::Response, response.class
      assert response.dig("errors").present?
    end
  end
end

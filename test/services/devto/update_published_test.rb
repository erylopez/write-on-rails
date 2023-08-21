require "test_helper"

class Devto::UpdatePublishedTest < ActiveSupport::TestCase
  test "Unpublish a post on devto" do
    VCR.use_cassette("devto/unpublish_post") do
      user = users(:one)
      post = user.posts.create(
        title: "testing publish and unpublish",
        md_content: "testing devto",
        devto_id: "12345"
      )
      published = false

      response = Devto::UpdatePublished.new(user: user, devto_id: post.devto_id, published: published).call
      assert_equal response.code, 200
    end
  end

  test "Publish a post on devto" do
    VCR.use_cassette("devto/publish_post") do
      user = users(:one)
      post = user.posts.create(
        title: "testing publish and unpublish",
        md_content: "testing devto",
        devto_id: "12345"
      )
      published = true

      response = Devto::UpdatePublished.new(user: user, devto_id: post.devto_id, published: published).call
      assert_equal response.code, 200
    end
  end
end

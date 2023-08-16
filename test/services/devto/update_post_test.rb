require "test_helper"

class Devto::UpdatePostTest < ActiveSupport::TestCase
  test "updates a post on devto" do
    VCR.use_cassette("devto/update_post") do
      user = users(:one)
      post = user.posts.create(
        title: "A test from the controller",
        md_content: "#Testing\n This is a **test** from the controller",
        devto_id: "123456"
      )

      response = Devto::UpdatePost.new(api_key: user.devto_api_key, post: post).call
      assert response.success?
    end
  end
end

require "test_helper"

class Post::UpdatePublishedTest < ActionDispatch::IntegrationTest
  test "A user can unpublish a post on Dev.to, and the 'devto_draft' attribute will be modified if the response is successful" do
    user = users(:one)
    post = user.posts.create(title: "title", md_content: "example", devto_draft: false, devto_id: "12345")
    platform = "Dev.to"
    published = false
    sign_in user

    assert_not post.devto_draft

    assert_changes -> { post.devto_draft } do
      VCR.use_cassette("devto/unpublish_post") do
        post "/posts/#{post.id}/update_published?platform=#{platform}&published=#{published}"

        post.update(devto_draft: !post.devto_draft)
        assert_response :redirect
        follow_redirect!

        assert_response :success
      end
    end

    assert post.devto_draft
  end
end

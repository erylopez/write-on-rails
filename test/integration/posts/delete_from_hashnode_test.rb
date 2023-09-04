require "test_helper"

class Post::DeleteFromHashnodeTest < ActionDispatch::IntegrationTest
  test "A user can delete a post from hashnode" do
    user = users(:one)
    post = user.posts.create(title: "title", md_content: "example", hashnode_draft: false, hashnode_id: "123456")
    sign_in user

    assert_changes -> { post.hashnode_id } do
      VCR.use_cassette("hashnode/remove_post") do
        post "/posts/#{post.id}/delete_from_hashnode"

        post.update(hashnode_id: nil)
        assert_response :redirect
        follow_redirect!

        assert_response :success
      end
    end

    assert_nil post.hashnode_id
  end

  test "A user cannot delete a post from hashnode without a hashnode_id" do
    user = users(:one)
    post = user.posts.create(title: "title", md_content: "example", hashnode_draft: false)
    sign_in user

    assert_no_changes -> { post.hashnode_id } do
      VCR.use_cassette("hashnode/remove_post") do
        post "/posts/#{post.id}/delete_from_hashnode"
        assert_response :redirect
        follow_redirect!

        assert_response :success
      end
    end

    assert_nil post.hashnode_id
  end
end

require "test_helper"

class PostTest < ActiveSupport::TestCase
  test "can create posts using notion oauth reponse" do
    user = users(:one)
    notion_reponse = {
      id: "notion_id", title: "notion title", md: "notion markdown", user_id: user.id
    }

    assert_difference "Post.count", 1 do
      Post.from_notion(notion_reponse)
    end
  end

  test "can have many comments" do
    post = posts(:one)
    comment = Comment.new(content: "This is a comment", post: post)

    assert comment.save
    assert comment.in?(post.comments)
  end
end

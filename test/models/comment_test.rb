require "test_helper"

class CommentTest < ActiveSupport::TestCase
  test "should not save comment without content" do
    comment = Comment.new
    assert_not comment.save
  end

  test "valid fixture with parent association" do
    parent = comments(:one)
    child = comments(:two)
    assert parent.comments.include?(child)
  end

  test "a comment can have children comments" do
    post = posts(:one)
    comment = Comment.new(content: "This is a comment", post: post)
    assert comment.save
    assert comment.comments.empty?

    child_comment = Comment.new(content: "This is a child comment", post: post, parent: comment)
    assert child_comment.save
    assert child_comment.in?(comment.comments)
  end
end

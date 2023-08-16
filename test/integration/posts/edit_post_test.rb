require "test_helper"

class Post::EditPostTest < ActionDispatch::IntegrationTest
  def setup
    sign_in users(:one)
    @post = users(:one).posts.create(title: "My first post", md_content: "This is a test post")
  end

  test "can navigate directly to the posts#edit page" do
    get "/posts/#{@post[:id]}/edit"
    assert_response :success
  end

  test "can navigate through the dashboard to the posts#edit page" do
    get "/"
    assert_redirected_to "/dashboard"
    follow_redirect!

    assert_response :success
    get "/posts/#{Post.last.id}/edit"
    assert_response :success
  end

  test "can edit a post with valid data" do
    get "/posts/#{@post.id}/edit"

    assert_dom "form[action=?]", "/posts/#{@post.id}"

    assert_no_changes -> { Post.count } do
      patch "/posts/#{@post.id}", params: {post: {title: "My first post edited", md_content: "This is a test post"}}
    end

    assert_redirected_to "/posts/#{@post.id}"
    follow_redirect!
    assert_response :success

    assert_dom "h5#title", "My first post edited"
  end

  test "cannot edit a post with invalid data" do
    get "/posts/#{@post.id}/edit"

    assert_dom "form[action=?]", "/posts/#{@post.id}"

    assert_no_changes -> { Post.count } do
      patch "/posts/#{@post.id}", params: {post: {title: "", md_content: "This is a test post"}}
    end

    assert_response :unprocessable_entity

    assert_dom "form[action=?]", "/posts/#{@post.id}"
  end
end

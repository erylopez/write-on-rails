require "test_helper"

class Post::CreatePostTest < ActionDispatch::IntegrationTest
  def setup
    sign_in users(:one)
  end

  test "can navigate directly to the posts#new page" do
    get "/posts/new"
    assert_response :success
  end

  test "can navigate through the dashboard to the posts#new page" do
    get "/"
    assert_redirected_to "/dashboard"
    follow_redirect!

    assert_response :success
    assert_dom "a[href=?]", "/posts/new"
    get "/posts/new"
    assert_response :success
  end

  test "can create a post with valid data" do
    get "/posts/new"

    assert_dom "form[action=?]", "/posts"

    assert_changes -> { Post.count } do
      post "/posts", params: {post: {title: "My first post", md_content: "This is a test post"}}
    end

    assert_redirected_to "/posts/#{Post.last.id}"
    follow_redirect!
    assert_response :success

    assert_dom "h2#title", "My first post"
  end

  test "cannot create a post with invalid data" do
    get "/posts/new"

    assert_dom "form[action=?]", "/posts"

    assert_no_changes -> { Post.count } do
      post "/posts", params: {post: {title: "", md_content: "This is a test post"}}
    end

    assert_response :unprocessable_entity

    assert_dom "form[action=?]", "/posts"
  end
end

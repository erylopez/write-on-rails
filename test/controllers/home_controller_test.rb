require "test_helper"

class HomeControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get "/"
    assert_equal path, root_path
    assert_response :success
  end
end

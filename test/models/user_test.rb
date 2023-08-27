require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "#devto_ready?" do
    empty_user = users(:empty)
    assert_not empty_user.devto_ready?
    user = users(:one)
    assert user.devto_ready?
  end

  test "#get_hashnode_publication_id without hashnode integration" do
    user = users(:empty)
    assert_not user.get_hashnode_publication_id
  end

  test "#get_hashnode_publication_id with hashnode integration" do
    user = users(:one)
    Hashnode::GetPublications.any_instance.stubs(:call).returns({
      "data" => {"user" => {"publication" => {"_id" => "publication_id_123"}}}
    })

    assert_equal user.get_hashnode_publication_id, "publication_id_123"
  end

  test "#get_hashnode_publication_id handles http errors" do
    HTTParty.stubs(:post).raises(HTTParty::Error)
    user = users(:one)
    assert_not user.get_hashnode_publication_id
  end
end

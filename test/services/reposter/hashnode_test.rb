require "test_helper"

class Reposter::HashnodeTest < ActiveSupport::TestCase
  test "reposts to hashnode" do
    user = users(:one)
    post = user.posts.create(title: "test", md_content: "test")
    # VCR confuses the responses if we dont use this cassette order.
    # Dont change the order of the cassettes
    VCR.insert_cassette("hashnode/create_post")
    VCR.insert_cassette("hashnode/publications")
    response = Reposter::Hashnode.new(post: post, user: user).call
    assert response
    assert post.reload.hashnode_id.present?
    assert user.hashnode_publication_id.present?
    VCR.eject_cassette(name: "hashnode/publications")
    VCR.eject_cassette(name: "hashnode/create_post")
  end
end

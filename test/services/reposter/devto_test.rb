require "test_helper"

class Reposter::DevtoTest < ActiveSupport::TestCase
  test "reposts to devto" do
    user = users(:one)
    post = user.posts.create(title: "test", md_content: "test")

    VCR.insert_cassette("devto/create_post")
    VCR.insert_cassette("devto/publications")
    response = Reposter::Devto.new(post: post, user: user).call
    assert response
    assert post.reload.devto_id.present?
    VCR.eject_cassette(name: "devto/publications")
    VCR.eject_cassette(name: "devto/create_post")
  end
end

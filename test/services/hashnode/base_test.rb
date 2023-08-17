require "test_helper"

class Hashnode::BaseTest < ActiveSupport::TestCase
  test "get_etag" do
    etag = Hashnode::Base.new.get_etag(title: "title", markdown: "markdown")
    assert etag.present?
  end

  test "get_base_post_url" do
    blog_handle = "blog-handle"
    publication_domain = "publication-domain"
    base_post_url = Hashnode::Base.new.get_base_post_url(
      blog_handle: blog_handle,
      publication_domain: publication_domain
    )
    assert_equal "https://#{publication_domain}", base_post_url

    base_post_url = Hashnode::Base.new.get_base_post_url(
      blog_handle: blog_handle,
      publication_domain: nil
    )
    assert_equal "https://#{blog_handle}.hashnode.dev", base_post_url
  end
end

class Hashnode::Base
  def get_etag(title:, markdown:)
    Base64.encode64(title + markdown).strip
  end

  def get_base_post_url(blog_handle:, publication_domain:)
    if publication_domain.present?
      "https://#{publication_domain}"
    else
      "https://#{blog_handle}.hashnode.dev"
    end
  end
end

class Hashnode::Base
  def get_etag(title:, markdown:)
    Base64.encode64(title + markdown).strip
  end
end

class Devto::Base
  def authentication_header(api_key)
    {
      "Content-Type" => "application/json",
      "Accept" => "application/vnd.forem.api-v1+json",
      "api-key" => api_key
    }
  end

  def get_etag(title:, markdown:)
    Digest::MD5.hexdigest("#{title}#{markdown}")
  end
end

class Devto::UpdatePublished < Devto::Base
  def initialize(user:, devto_id:, published:)
    @api_key = user.devto_api_key
    @devto_id = devto_id
    @published = published
  end

  def call
    body = {
      article: {
        published: @published
      }
    }.to_json

    HTTParty.put("https://dev.to/api/articles/#{@devto_id}", body: body, headers: authentication_header(@api_key))
  end
end

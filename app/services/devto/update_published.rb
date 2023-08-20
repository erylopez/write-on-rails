class Devto::UpdatePublished < Devto::Base
  def initialize(user:, post:, published:)
    @api_key = user.devto_api_key
    @post = post
    @published = published
  end

  def call
    body = {
      article: {
        published: @published
      }
    }.to_json

    HTTParty.put("https://dev.to/api/articles/#{@post.devto_id}", body: body, headers: authentication_header(@api_key))
  end
end

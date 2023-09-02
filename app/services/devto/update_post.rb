class Devto::UpdatePost < Devto::Base
  def initialize(user:, post:)
    @api_key = user.devto_api_key
    @post = post
  end

  def call
    body = {
      article: {
        title: @post.title,
        body_markdown: @post.md_content,
        tags: "rails, ruby, rubyonrails"
      }
    }.to_json

    HTTParty.put("https://dev.to/api/articles/#{@post.devto_id}", body: body, headers: {"Content-Type": "application/json", "api-key": @api_key})
  end
end

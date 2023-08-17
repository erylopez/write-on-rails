class Devto::CreatePost < Devto::Base
  def initialize(api_key:, post:)
    @api_key = api_key
    @post = post
  end

  def call
    body = {
      article: {
        title: @post.title,
        published: true,
        body_markdown: @post.md_content,
        tags: "rails, ruby, rubyonrails"
      }
    }.to_json

    HTTParty.post("https://dev.to/api/articles", body: body, headers: authentication_header(@api_key))
  end
end

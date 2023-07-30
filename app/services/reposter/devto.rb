class Reposter::Devto
  def initialize(post:, user:)
    @post = post
    @user = user
  end

  def call
    response = Devto::CreateArticle.new(api_key: @user.devto_api_key, article: @post).call

    @post.update(devto_id: response.dig("id"), devto_slug: response.dig("slug"), devto_url: response.dig("url"))
  end
end

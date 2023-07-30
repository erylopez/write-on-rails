class Reposter::Devto
  def initialize(post:, user:)
    @post = post
    @user = user
  end

  def call
    response = Devto::CreatePost.new(api_key: @user.devto_api_key, post: @post).call

    @post.update(devto_id: response.dig("id"), devto_slug: response.dig("slug"), devto_url: response.dig("url"))
  end
end

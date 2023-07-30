class Reposter::Hashnode
  def initialize(post:, user:)
    @post = post
    @user = user
  end

  def call
    publications = Hashnode::GetPublications.new(authorization_code: @user.hashnode_access_token, username: @user.hashnode_username).call
    publication_id = publications.dig("data", "user", "publication", "_id")

    @user.update(hashnode_blog_handle: publications.dig("data", "user", "blogHandle") if @user.hashnode_blog_handle.blank?

    response = Hashnode::CreatePost.new(authorization_code: @user.hashnode_access_token, publication_id: publication_id, post: @post).call

    @post.update(hashnode_id: response.dig("data", "createStory", "post", "_id"), hashnode_slug: response.dig("data", "createStory", "post", "slug"))
  end
end

class Reposter::Hashnode
  def initialize(post:, user:)
    @post = post
    @user = user
  end

  def call
    response = Hashnode::CreatePost.new(
      authorization_code: @user.hashnode_access_token,
      publication_id: @user.get_hashnode_publication_id,
      post: @post
    ).call

    @post.update(hashnode_id: response.dig("data", "createStory", "post", "_id"), hashnode_slug: response.dig("data", "createStory", "post", "slug"))
  end
end

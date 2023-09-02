class Hashnode::SyncStats < Hashnode::Base
  def initialize(user:)
    @authorization_code = user.hashnode_access_token
    @username = user.hashnode_username
    @user = user
  end

  def call
    return if @authorization_code.blank?
    return if @username.blank?
    page = 0
    posts = []

    loop do
      response = HTTParty.post("https://api.hashnode.com", body: {query: get_user_posts_query(page:)}.to_json, headers: headers)
      break if response.dig("data", "user", "publication", "posts").try(:empty?)
      posts << response.dig("data", "user", "publication", "posts")
      page += 1
    end

    posts.flatten.map do |post|
      sync_stats_for(post)
    end
  end

  def sync_stats_for(hashnode_post)
    post = Post.where(hashnode_id: hashnode_post["_id"]).first
    return if post.blank?

    post.update(
      hashnode_reply_count: hashnode_post["responseCount"],
      hashnode_reactions: hashnode_post["totalReactions"],
      hashnode_views: hashnode_post["views"]
    )
  end
end

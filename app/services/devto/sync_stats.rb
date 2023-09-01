class Devto::SyncStats < Devto::Base
  attr_accessor :user

  def initialize(user:)
    @user = user
  end

  def call
    page = 0

    loop do
      page += 1
      devto_posts = HTTParty.get("https://dev.to/api/articles/me/all?per_page=30&page=#{page}",
        headers: authentication_header(@user.devto_api_key))

      break if devto_posts.empty?

      devto_posts.map { |post| sync_stats_for(post) }
    end
  end

  def sync_stats_for(devto_post)
    post = Post.where(devto_id: devto_post["id"]).first
    return if post.blank?

    post.update(
      devto_comments_count: devto_post["comments_count"],
      devto_reactions: devto_post["positive_reactions_count"],
      devto_views: devto_post["page_views_count"]
    )
  end
end

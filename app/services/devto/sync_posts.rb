class Devto::SyncPosts < Devto::Base
  def initialize(user:)
    @user = user
  end

  def call
    return if @user.devto_api_key.blank?

    # TODO: Implement pagination
    posts = HTTParty.get("https://dev.to/api/articles/me/all?per_page=1000",
      headers: authentication_header(@user.devto_api_key))

    posts.each do |post|
      our_post = Post.where(devto_id: post.dig("id"), user_id: @user.id).first_or_create do |new_post|
        new_post.devto_id = post.dig("id")
        new_post.title = post.dig("title")
        new_post.md_content = post.dig("body_markdown")
        new_post.devto_draft = !post.dig("published")
        new_post.devto_slug = post.dig("slug")
        new_post.devto_url = post.dig("url")
        new_post.devto_comments_count = post.dig("comments_count")
        new_post.devto_reactions = post.dig("positive_reactions_count")
        new_post.devto_views = post.dig("page_views_count")
        new_post.devto_tags = post.dig("tag_list").to_s
        new_post.devto_cover_image = post.dig("cover_image")
        new_post.devto_etag = get_etag(title: post.dig("title"), markdown: post.dig("body_markdown"))
      end

      if our_post.hashnode_etag != get_etag(title: post.dig("title"), markdown: post.dig("contentMarkdown"))
        our_post.update(
          title: post.dig("title"),
          md_content: post.dig("body_markdown"),
          devto_draft: !post.dig("published"),
          devto_slug: post.dig("slug"),
          devto_url: post.dig("url"),
          devto_comments_count: post.dig("comments_count"),
          devto_reactions: post.dig("positive_reactions_count"),
          devto_views: post.dig("page_views_count"),
          devto_tags: post.dig("tag_list").to_s,
          devto_cover_image: post.dig("cover_image"),
          devto_etag: get_etag(title: post.dig("title"), markdown: post.dig("body_markdown"))
        )
      end
    end

    posts
  end
end

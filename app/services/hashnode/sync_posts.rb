class Hashnode::SyncPosts < Hashnode::Base
  def initialize(user:)
    @authorization_code = user.hashnode_access_token
    @username = user.hashnode_username
    @user = user
  end

  def call
    return if @authorization_code.blank?
    return if @username.blank?

    headers = {"Content-Type": "application/json", Authorization: @authorization_code}
    page = 0

    response = HTTParty.post("https://api.hashnode.com", body: {query: query(page:)}.to_json, headers: headers)
    posts = response.dig("data", "user", "publication", "posts")

    while response.dig("data", "user", "publication", "posts").any?
      page += 1
      response = HTTParty.post("https://api.hashnode.com", body: {query: query(page:)}.to_json, headers: headers)
      posts += response.dig("data", "user", "publication", "posts")
    end

    base_post_url ||= get_base_post_url(
      blog_handle: response.dig("data", "user", "blogHandle"),
      publication_domain: response.dig("data", "user", "publicationDomain")
    )

    posts.each do |post|
      our_post = Post.where(hashnode_id: post.dig("_id"), user_id: @user.id).first_or_create do |new_post|
        new_post.title = post.dig("title")
        new_post.md_content = post.dig("contentMarkdown")
        new_post.hashnode_slug = post.dig("slug")
        new_post.hashnode_views = post.dig("views")
        new_post.hashnode_draft = !post.dig("isActive")
        new_post.hashnode_reactions = post.dig("totalReactions")
        new_post.hashnode_reply_count = post.dig("replyCount")
        new_post.hashnode_cover_image = post.dig("coverImage")
        new_post.hashnode_response_count = post.dig("responseCount")
        new_post.hashnode_url = "#{base_post_url}/#{post.dig("slug")}"
        new_post.hashnode_etag = get_etag(title: post.dig("title"), markdown: post.dig("contentMarkdown"))
      end

      if our_post.hashnode_etag != get_etag(title: post.dig("title"), markdown: post.dig("contentMarkdown"))
        our_post.update(
          title: post.dig("title"),
          md_content: post.dig("contentMarkdown"),
          hashnode_slug: post.dig("slug"),
          hashnode_views: post.dig("views"),
          hashnode_draft: !post.dig("isActive"),
          hashnode_reactions: post.dig("totalReactions"),
          hashnode_reply_count: post.dig("replyCount"),
          hashnode_response_count: post.dig("responseCount"),
          hashnode_cover_image: post.dig("coverImage"),
          hashnode_url: "#{base_post_url}/#{post.dig("slug")}",
          hashnode_etag: get_etag(title: post.dig("title"), markdown: post.dig("contentMarkdown"))
        )
      end
    end

    response
  end

  def query(page: 0)
    %{
      {
        user(username: "#{@username}") {
          blogHandle
          publicationDomain
          publication {
            posts(page: #{page}) {
              coverImage
              followersCount
              _id
              cuid
              slug
              title
              popularity
              totalReactions
              partOfPublication
              isActive
              replyCount
              responseCount
              dateAdded
              brief
              dateUpdated
              dateFeatured
              contentMarkdown
              numUniqueUsersWhoReacted
              readTime
              views
            }
          }
        }
      }
    }
  end
end

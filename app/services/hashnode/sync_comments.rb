class Hashnode::SyncComments < Hashnode::Base
  def initialize(post:)
    @post = post
    @authorization_code = post.user.hashnode_access_token
  end

  def call
    query = post_with_comments_query(slug: @post.hashnode_slug, hostname: @post.user.hashnode_blog_handle)
    response = HTTParty.post("https://api.hashnode.com", body: {query: query}.to_json, headers: headers)
    comments = response.dig("data", "post", "responses")
    return if comments.try(:empty?)

    comments.each do |hashnode_comment|
      comment = Comment.where(hashnode_comment_id: hashnode_comment["_id"], post: @post).first_or_create do |new_comment|
        new_comment.content = hashnode_comment["content"]
      end

      comment.update(content: hashnode_comment["content"]) if comment.content != hashnode_comment["content"]

      hashnode_comment["replies"].each do |hashnode_reply|
        reply = Comment.where(hashnode_comment_id: hashnode_reply["_id"], post: @post).first_or_create do |new_reply|
          new_reply.parent  = comment
          new_reply.content = hashnode_reply["content"]
        end

        reply.update(content: hashnode_reply["content"]) if reply.content != hashnode_reply["content"]
      end
    end

    response
  end

  def post_with_comments_query(slug:, hostname:)
    %(
      {
        post(slug: "#{slug}", hostname: "#{hostname}.hashnode.dev") {
          _id
          responses {
            _id
            content
            contentMarkdown
            stamp
            post
            totalReactions
            isCollapsed
            isActive
            dateAdded
            popularity
            replies {
              _id
              isActive
              stamp
              totalReactions
            }
          }
        }
      }
    )
  end
end

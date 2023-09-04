class Devto::SyncComments < Devto::Base
  attr_accessor :post

  def initialize(post:)
    @post = post
  end

  def call
    devto_comments = HTTParty.get("https://dev.to/api/comments?a_id=#{post.devto_id}")
    devto_comments.map do |devto_comment|
      comment = Comment.where(devto_comment_id: devto_comment["id_code"], post: @post).first_or_create do |new_comment|
        new_comment.content = devto_comment["body_html"]
      end

      comment.update(content: devto_comment["body_html"]) if comment.content != devto_comment["body_html"]

      devto_comment["children"].each do |devto_reply|
        reply = Comment.where(devto_comment_id: devto_reply["id_code"], post: @post).first_or_create do |new_reply|
          new_reply.parent  = comment
          new_reply.content = devto_reply["body_html"]
        end

        reply.update(content: devto_reply["body_html"]) if reply.content != devto_reply["body_html"]
      end
    end

    devto_comments
  end
end

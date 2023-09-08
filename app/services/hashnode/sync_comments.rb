class Hashnode::SyncComments < Hashnode::Base
  def initialize(post:)
    @post = post
    @authorization_code = post.user.hashnode_access_token
  end

  def call
    end_cursor = ""
    comments = []
    response = nil

    loop do
      response = HTTParty.post("https://gql.hashnode.com", body: {query:, variables: variables(end_cursor: end_cursor)}.to_json, headers: headers)
      has_next_page = response.dig("data", "publication", "post", "comments", "pageInfo", "hasNextPage")
      end_cursor = response.dig("data", "publication", "post", "comments", "pageInfo", "endCursor")
      comments.concat(response.dig("data", "publication", "post", "comments", "edges").pluck("node"))
      break unless has_next_page
    end

    return unless comments&.any?

    comments.each do |hashnode_comment|
      comment = Comment.where(hashnode_comment_id: hashnode_comment["id"], post: @post).first_or_create do |new_comment|
        new_comment.content = hashnode_comment.dig("content", "html")
        new_comment.author_name = hashnode_comment.dig("author", "name")
        new_comment.author_avatar = hashnode_comment.dig("author", "profilePicture") || "/default-avatar.png"
      end

      comment.update(content: hashnode_comment.dig("content", "html")) if comment.content != hashnode_comment.dig("content", "html")

      hashnode_comment.dig("replies", "edges").pluck("node").each do |hashnode_reply|
        reply = Comment.where(hashnode_comment_id: hashnode_reply["id"], post: @post).first_or_create do |new_reply|
          new_reply.parent  = comment
          new_reply.content = hashnode_reply.dig("content", "html")
          new_reply.author_name = hashnode_reply.dig("author", "name")
          new_reply.author_avatar = hashnode_reply.dig("author", "profilePicture") || "/default-avatar.png"
        end

        reply.update(content: hashnode_reply.dig("content", "html")) if reply.content != hashnode_reply.dig("content", "html")
      end
    end

    response
  end

  def variables(end_cursor: "")
    {
      "slug" => @post.hashnode_slug,
      "host" => "#{@post.user.hashnode_blog_handle}.hashnode.dev",
      "after" => end_cursor
    }
  end

  def query
    %{
      query getComments($after: String, $host: String!, $slug: String!) {
        publication(host: $host) {
          post(slug: $slug){
            comments(first: 50, after: $after) {
              totalDocuments
              pageInfo {
                hasNextPage
                endCursor
              }
              edges {
                cursor
                node {
                  id
                  content {
                    html
                  }
                  totalReactions
                  author {
                    name
                    username
                    profilePicture
                  }
                  replies(first: 50){
                    edges{
                      node {
                        id
                        content { html }
                        author {
                          name
                          username
                          profilePicture
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
    }.gsub(/\n+/, " ").strip
  end
end

class Hashnode::Base
  def get_etag(title:, markdown:)
    Base64.encode64(title + markdown).strip
  end

  def get_base_post_url(blog_handle:, publication_domain:)
    if publication_domain.present?
      "https://#{publication_domain}"
    else
      "https://#{blog_handle}.hashnode.dev"
    end
  end

  def headers
    {"Content-Type": "application/json", Authorization: @authorization_code}
  end

  def get_user_posts_query(page: 0)
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

  def with_frontmatter(post)
    %(---
      title: A frontmatter example to test in the APIv2 from Hashnode
      subtitle: An example subtitle
      slug: post-with-frontmatter
      tags: ruby,ruby-on-rails,ror
      cover: https://cdn.hashnode.com/res/hashnode/image/upload/v1649662225945/7f_c6UxhR.jpg?auto=compress
      domain:
      saveAsDraft: true
      ---

      #{post.md_content}
    )
  end
end

module ApplicationHelper
  def notion_oauth_url
    redirect_url = CGI.escape(users_auth_notion_callback_url)
    "https://api.notion.com/v1/oauth/authorize?client_id=#{Rails.application.credentials.notion[:client_id]}&response_type=code&owner=user&redirect_uri=#{redirect_url}"
  end

  def render_badge(text:, color:)
    tailwind_classes = "bg-#{color}-200/50 text-#{color}-700 text-sm font-medium inline-flex items-center px-2.5 py-0.5 rounded dark:bg-#{color}-700/50 dark:text-#{color}-200 border border-#{color}-400"
    "<span class='#{tailwind_classes}'>#{text}</span>".html_safe
  end

  def active_path(path)
    current_page?(path) ? "active_nav" : ""
  end

  def embedded_svg(filename, options = {})
    assets = Rails.application.assets
    asset = assets.find_asset(filename)

    if asset
      file = asset.source.force_encoding("UTF-8")
      doc = Nokogiri::HTML::DocumentFragment.parse file
      svg = doc.at_css "svg"
      svg["class"] = options[:class] if options[:class].present?
    else
      doc = "<!-- SVG #{filename} not found -->"
    end

    raw doc
  end

  def nav_list
    [
      {
        name: "Dashboard",
        path: dashboard_index_path,
        icon: "book-open"
      },
      {
        name: "Profile",
        path: profile_path,
        icon: "user"
      },
      {
        name: "Posts",
        path: posts_path,
        icon: "document-duplicate"
      },
      {
        name: "New Post",
        path: new_post_path,
        icon: "pencil-square"
      },
      {
        name: "Leaderboard",
        path: "#",
        icon: "",
        inactive: true
      }
    ]
  end

  def popularity_statistics
    [
      {
        name: "Followers",
        count: "0",
        icon: "user-group"
      },
      {
        name: "Posts",
        count: current_user.posts.count,
        icon: "document-duplicate"
      },
      {
        name: "Likes",
        count: "0",
        icon: "heart"
      },
      {
        name: "Comments",
        count: "0",
        icon: "chat-bubble-bottom-center"
      }
    ]
  end

  def github_data
    [
      {content: current_user.github_company, icon: "company"},
      {content: current_user.github_location, icon: "location"},
      {content: current_user.email, icon: "envelope"}
    ]
  end

  def post_platforms(post)
    [
      {
        name: "Hashnode",
        id: post.hashnode_id,
        url: post.hashnode_url
      },
      {
        name: "Dev.to",
        id: post.devto_id,
        url: post.devto_url
      },
      {
        name: "Medium",
        id: post.medium_id,
        url: post.medium_id
      }
    ]
  end
end

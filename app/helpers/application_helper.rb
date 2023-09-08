module ApplicationHelper
  def notion_oauth_url
    redirect_url = CGI.escape(users_auth_notion_callback_url)
    "https://api.notion.com/v1/oauth/authorize?client_id=#{Rails.application.credentials.notion[:client_id]}&response_type=code&owner=user&redirect_uri=#{redirect_url}"
  end

  def render_badge(text:, color:)
    tailwind_classes = "bg-#{color}-200/50 text-#{color}-700 text-sm font-medium inline-flex items-center px-2.5 py-0.5 rounded dark:bg-#{color}-700/50 dark:text-#{color}-200 border border-#{color}-400"
    "<span class='#{tailwind_classes}'>#{text}</span>".html_safe
  end

  def active_path(controllers)
    controller_action = "#{params[:controller]}/#{params[:action]}"
    if controller_action.in?(controllers)
      "active_nav"
    end
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
        controllers: ["dashboard/index"],
        icon: "book-open"
      },
      {
        name: "Profile",
        path: profile_index_path,
        controllers: ["profile/index"],
        icon: "user"
      },
      {
        name: "Posts",
        path: posts_path,
        controllers: ["posts/index", "posts/show", "posts/edit"],
        icon: "document-duplicate"
      },
      {
        name: "New Post",
        path: new_post_path,
        controllers: ["posts/new"],
        icon: "pencil-square"
      },
      {
        name: "Leaderboard",
        path: "#",
        controllers: [],
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

  def publish_devto_toggle_link(post:)
    if post.published?("Dev.to")
      link_to "Unpublish", update_published_status_from_devto_post_path(post, published: false), data: {turbo_method: :post}, class: "button-danger"
    else
      link_to "Publish", update_published_status_from_devto_post_path(post, published: true), data: {turbo_method: :post}, class: "button-default"
    end
  end

  def published_or_draft(post:, platform:)
    if post.published?(platform)
      "Published"
    else
      "Draft"
    end
  end

  def import_posts_link(platform:)
    if current_user.send("#{platform}_ready?")
      link_to "Import Posts from #{platform.capitalize}", sync_posts_path(platform: platform), data: {turbo_method: :post}, class: "button-default w-full"
    end
  end

  def sync_stats_link(platform:)
    if current_user.send("#{platform}_ready?")
      link_to "Sync Stats from #{platform.capitalize}", sync_stats_path(platform: platform), data: {turbo_method: :post}, class: "button-default w-full bg-purple-600" if current_user.posts.send("#{platform}_posts").any?
    else
      link_to "Connect #{platform.capitalize}", send("auth_#{platform}_callback_path"), class: "button-default w-full bg-purple-600"
    end
  end

  def integration_box_content(platform:)
    content_tag(:div, class: "flex items-center text-base font-bold text-gray-900 dark:text-gray-300") do
      concat image_tag("/#{platform}.png", alt: "writing photo", class: "w-6 h-6")
      concat content_tag(:span, platform.capitalize, class: "flex-1 ml-2 whitespace-nowrap")
      concat content_tag(:span, "Synced", class: "text-sm font-light") if current_user.send("#{platform}_ready?")
    end
  end

  def flash_messages(type:, message:)
    color = (type == "notice" || type == "success") ? "green" : "red"
    icon  = (type == "notice" || type == "success") ? "check-circle" : "exclamation-circle"

    content_tag(:div, id: "alertBox", data: {"flash-target" => "alertBox"}, class: "fixed bottom-0 w-1/4 flex items-center p-4 mb-4 text-gray-200 bg-#{color}-600 border border-#{color}-700 rounded-lg transform transition-transform duration-500 ease-in-out") do
      concat embedded_svg(icon, class: "w-8 h-8")
      concat content_tag(:div, message, class: "ml-2 text-sm font-medium")
      concat(
        content_tag(:button, data: {"action" => "click->flash#close"}, class: "ml-auto -mx-1.5 -my-1.5 text-#{color}-400 rounded-lg p-1.5 hover:text-gray-200 inline-flex items-center justify-center h-8 w-8 dark:text-#{color}-400") do
          concat embedded_svg("close", class: "w-3 h-3")
        end
      )
    end
  end
end

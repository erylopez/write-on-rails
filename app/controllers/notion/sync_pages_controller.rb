class Notion::SyncPagesController < ApplicationController
  def index
    client = Notion::Client.new(token: current_user.notion_access_token)
    # databases = client.search(filter: { property: 'object', value: 'database' })
    template = client.block_children(block_id: current_user.notion_page_id)
    database_id = template&.results&.find{|r| r.type == "child_database"}.try(:id)

    render json: [] unless database_id

    pages = []

    # TODO:
    # We can then filter by last_edited_time to update existing posts too instead of just creating new ones once.
    # client.database_query(database_id: database_id, filter: {timestamp: "last_edited_time", last_edited_time: {on_or_before: "2023-07-30T18:59:00.000Z"}})
    client.database_query(database_id: database_id) do |results_page|
      results_page.results.each do |page|
        notion_converter = NotionToMd::Converter.new(page_id: page.id, token: current_user.notion_access_token)
        md = notion_converter.convert(frontmatter: true)
        post = Post.from_notion({id: page.id, title: page.properties["Name"].title.first.plain_text, md: md, user_id: current_user.id})
        pages << post.to_json
      end
    end

    redirect_to dashboard_index_path
  end
end

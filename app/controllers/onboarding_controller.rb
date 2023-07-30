class OnboardingController < ApplicationController
  def index
  end

  def notion_fetch_page
    client = Notion::Client.new(token: current_user.notion_access_token)
    databases = client.search(filter: { property: 'object', value: 'database' })

    pages = []
    client.database_query(database_id: databases.results.first.id) do |results_page|
      results_page.results.each { |page| pages << page.properties["Name"].title.first.plain_text }
    end
    
    render turbo_stream: turbo_stream.replace(:pages, partial: "onboarding/pages", locals: { pages: pages })
  end
end

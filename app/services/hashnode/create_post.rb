class Hashnode::CreatePost
  def initialize(authorization_code:, publication_id:)
    @authorization_code = authorization_code
    @publication_id = publication_id
  end

  def call
    query = %{
      mutation createStory($input: CreateStoryInput!){
        createStory(input: $input) {
          code success message
        }
      }
    }.gsub(/\n+/, " ").strip
    
    variables =  {
      input: {
        title: 'What are the e2e testing libraries you use ?',
        isPartOfPublication: {publicationId:  @publication_id},
        contentMarkdown: '# You can put Markdown here.\n***\n',
        tags: [
          {
            _id: '56744723958ef13879b9549b',
            slug: 'testing',
            name: 'Testing',
          },
        ],
        coverImageURL: 'https://images.unsplash.com/photo-1575620442792-9a2688f60570?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=3270&q=80',
      },
    }

    headers = { "Content-Type": "application/json", "Authorization": @authorization_code}

    HTTParty.post("https://api.hashnode.com", body: {query: query, variables: variables}.to_json, headers: headers)
  end
end

class Hashnode::CreatePost < Hashnode::Base
  def initialize(authorization_code:, publication_id:, post:)
    @authorization_code = authorization_code
    @publication_id = publication_id
    @post = post
  end

  def call
    query = %{
      mutation createStory($input: CreateStoryInput!){
        createStory(input: $input) {
          code
          success
          message
          post {
            _id
            cuid
            slug
          }
        }
      }
    }.gsub(/\n+/, " ").strip

    variables = {
      input: {
        isPartOfPublication: {publicationId: @publication_id},
        title: @post.title,
        contentMarkdown: @post.md_content,
        tags: [
          {
            _id: "56744723958ef13879b9549b",
            slug: "testing",
            name: "Testing"
          }
        ]
      }
    }

    HTTParty.post("https://api.hashnode.com", body: {query: query, variables: variables}.to_json, headers: headers)
  end
end

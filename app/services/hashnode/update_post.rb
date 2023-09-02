class Hashnode::UpdatePost < Hashnode::Base
  def initialize(authorization_code:, publication_id:, post:)
    @authorization_code = authorization_code
    @publication_id = publication_id
    @post = post
  end

  def call
    query = %{
      mutation updateStory($input: UpdateStoryInput!, $postId: String!) {
        updateStory(input: $input, postId: $postId) {
            code
            success
            message
            post {
                _id
                dateAdded
                dateUpdated
            }
        }
    }
    }.gsub(/\n+/, " ").strip

    variables = {
      input: {
        isPartOfPublication: {publicationId: @publication_id},
        title: @post.title,
        contentMarkdown: @post.md_content,
        tags: []
      },
      postId: @post.hashnode_id
    }

    HTTParty.post("https://api.hashnode.com", body: {query: query, variables: variables}.to_json, headers: headers)
  end
end

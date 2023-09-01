class Hashnode::DeletePost < Hashnode::Base
  def initialize(authorization_code:, publication_id:, post:)
    @authorization_code = authorization_code
    @publication_id = publication_id
    @post = post
  end

  def call
    query = %{
      mutation deletePost($id: String!){
        deletePost(id: $id){
          code
          success
          message
        }
      }
    }.gsub(/\n+/, " ").strip

    variables = {id: @post.hashnode_id}

    HTTParty.post("https://api.hashnode.com", body: {query: query, variables: variables}.to_json, headers: headers)
  end
end

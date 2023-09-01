class Hashnode::DeletePost < Hashnode::Base
  def initialize(user:, post:)
    @user = user
    @post = post
    @authorization_code = user.hashnode_access_token
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

    headers = {"Content-Type": "application/json", Authorization: @authorization_code}

    HTTParty.post("https://api.hashnode.com", body: {query: query, variables: variables}.to_json, headers: headers)
  end
end

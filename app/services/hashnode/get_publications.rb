class Hashnode::GetPublications < Hashnode::Base
  def initialize(authorization_code:, username:)
    @authorization_code = authorization_code
    @username = username
  end

  def call
    query = %{
      {
        user(username: "#{@username}") {
          username
          name
          tagline
          blogHandle
          publication {
            _id
            title
            domain
            username
            isActive
          }
          publicationDomain
        }
      }
    }
    
    headers = { "Content-Type": "application/json", "Authorization": @authorization_code}

    HTTParty.post("https://api.hashnode.com", body: {query: query}.to_json, headers: headers)
  end
end

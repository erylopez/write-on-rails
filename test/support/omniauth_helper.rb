module OmniauthHelper
  def auth_data
    OmniAuth::AuthHash.new({
      provider: "github",
      uid: "123545",
      info: {email: "some@email.com",
             name: "John",
             image: "https://avatars.githubusercontent.com/u/7799551?v=4",
             nickname: "john123"},
      extra: {raw_info: {
        company: nil,
        location: nil,
        bio: nil
      }},
      credentials: {token: "randomtoken123456"}
    })
  end
end

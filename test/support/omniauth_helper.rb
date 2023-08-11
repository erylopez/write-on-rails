module OmniauthHelper
  def auth_data
    OmniAuth::AuthHash.new({
      provider: "github",
      uid: "123545",
      info: {email: "some@email.com"},
      credentials: {token: "randomtoken123456"}
    })
  end
end

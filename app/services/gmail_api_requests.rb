class GmailApiRequests
  def initialize(user)
    @user = user[:user]
    @token = token_from(@user.google_access_token)
  end

  def call
    response_object = @token.get(
    '/gmail/v1/users/me/labels/UNREAD'
    )
    return JSON.parse(response_object.body)["messagesUnread"]
  end

  private

  def token_from(token_hash)

    client_request = OAuth2::Client.new(
      ENV['GOOGLE_CLIENT_ID'],
      ENV['GOOGLE_CLIENT_SECRET'],
      {
        site: 'https://www.googleapis.com'
      }
    )

    token = OAuth2::AccessToken.from_hash(client_request, token_hash)

    if token.expired?
      client = OAuth2::Client.new(
        ENV['GOOGLE_CLIENT_ID'],
        ENV['GOOGLE_CLIENT_SECRET'],
        {
          site: 'https://accounts.google.com',
          authorize_url: "/o/oauth2/auth",
          token_url: "/o/oauth2/token"
        }
      )
      token = OAuth2::AccessToken.from_hash(client, refresh_token: token_hash[:refresh_token])
      new_token = token.refresh!
      @user.update(google_access_token: new_token.to_hash)
      token_hash = @user.google_access_token
      token_from(token_hash)
    end
    token
  end
end

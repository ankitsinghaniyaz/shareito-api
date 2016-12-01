class Facebook
  # Exchange Short access token for long lived access token
  def self.access_token(temporary_token)
    @oauth = Koala::Facebook::OAuth.new(
      ENV['FACEBOOK_APP_ID'],
      ENV['FACEBOOK_SECRET'],
      facebook_callback_accounts_url
    )

    @oauth.get_access_token(temporary_token)
  rescue Koala::Facebook::AuthenticationError => e
    nil
  rescue Faraday::ConnectionFailed => e
    nil
  end

  def self.profile(temporary_token)
    @graph = Koala::Facebook::API.new(temporary_token)
    @graph.get_object('me', {fields: ["name", "id", "email"]})
  rescue Koala::Facebook::AuthenticationError => e
    nil
  rescue Faraday::ConnectionFailed => e
    nil
  end

  # gets a list of all pages with give user
  def self.pages
  end
end

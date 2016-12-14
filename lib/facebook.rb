class Facebook
  # Exchange Short access token for long lived access token
  def self.access_token(temporary_token)
    @oauth = Koala::Facebook::OAuth.new(
      ENV['FACEBOOK_APP_ID'],
      ENV['FACEBOOK_SECRET']
    )

    @oauth.exchange_access_token_info(temporary_token)
  rescue Koala::Facebook::AuthenticationError => e
    nil
  rescue Faraday::ConnectionFailed => e
    nil
  end

  def self.profile(token)
    @graph = Koala::Facebook::API.new(token)
    @graph.get_object('me', {fields: ['name', 'id', 'email', 'picture']})
  rescue Koala::Facebook::AuthenticationError => e
    Rails.logger.error {"Facebook Authentication Error.."}
    nil
  rescue Faraday::ConnectionFailed => e
    Rails.logger.error {"Connection Failed.."}
    nil
  end

  # gets a list of all pages with give user
  def self.pages(token)
    @graph = Koala::Facebook::API.new(token)
    @graph.get_connection('me', 'accounts', {fields: ['name', 'id', 'picture', 'access_token']})
  rescue Koala::Facebook::AuthenticationError => e
    Rails.logger.error {"Facebook Authentication Error.."}
    nil
  rescue Faraday::ConnectionFailed => e
    Rails.logger.error {"Connection Failed.."}
    nil
  end

  # gets a list of all groups for the user
  def self.groups(token)
    @graph = Koala::Facebook::API.new(token)
    @graph.get_connection('me', 'groups', {fields: ['name', 'id', 'picture']})
  rescue Koala::Facebook::AuthenticationError => e
    Rails.logger.error {"Facebook Authentication Error.."}
    nil
  rescue Faraday::ConnectionFailed => e
    Rails.logger.error {"Connection Failed.."}
    nil
  end

  # creates account object for all given ids
  def self.create_accounts(ids, token, team_id)
    token_info = access_token(token)
    token = token_info["access_token"]
    if token_info["expires"].nil?
      expires_at = nil
    else
      expires_at = Time.current + token_info["expires"].to_i.seconds
    end

    # now based on that condition get
    profile = profile(token)
    pages = pages(token)
    groups = groups(token)

    # now create object for each of these:
    accounts = [];
    accounts.concat(create_account_for_profile(ids, profile, token, expires_at, team_id))
    accounts.concat(create_account_for_pages(ids, pages, team_id))
    accounts.concat(create_account_for_groups(ids, groups, token, expires_at, team_id))

    return accounts
  end


  # check if profile doesn't exist then create a new profile
  def self.create_account_for_profile(ids, profile, token, expires_at, team_id)
    if !ids.include?(profile["id"])
      return []
    end
    account = Account.find_by(team_id: team_id, source_id: profile["id"]) || Account.new
    account.assign_attributes(
      team_id: team_id,
      source_id: profile["id"],
      name: profile["name"],
      token: token,
      expires_at: expires_at,
      image: profile.dig('picture', 'data', 'url'),
      account_type: 'profile',
      remote_source: 'facebook'
    )
    return [account]
  end

  def self.create_account_for_pages(ids, pages, team_id)
    accounts = []
    pages.each do |page|
      if !ids.include?(page["id"])
        next
      end
      account = Account.find_by(team_id: team_id, source_id: page["id"]) || Account.new
      account.assign_attributes(
        team_id: team_id,
        source_id: page["id"],
        name: page["name"],
        token: page["access_token"],
        image: page.dig('picture', 'data', 'url'),
        account_type: 'page',
        remote_source: 'facebook'
      )
      accounts.push(account)
    end
    return accounts;
  end

  def self.create_account_for_groups(ids, groups, token, expires_at, team_id)
    accounts = []
    groups.each do |group|
      if !ids.include?(group["id"])
        next
      end
      account = Account.find_by(team_id: team_id, source_id: group["id"]) || Account.new
      account.assign_attributes(
        team_id: team_id,
        source_id: group["id"],
        name: group["name"],
        token: token,
        expires_at: expires_at,
        image: group.dig('picture', 'data', 'url'),
        account_type: 'community',
        remote_source: 'facebook'
      )
      accounts.push(account)
    end
    return accounts;
  end
end

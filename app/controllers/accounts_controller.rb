class AccountsController < ApplicationController
  # Exchange token for long lived access token with facebook
  # POST /accounts/facebook?access_token=fadsdfaadsf
  def facebook
    token = Facebook.access_token(params['access_token'])

    ## Create new account
    facebook = Account.new(facebook_params)
    facebook.token = token
    facebook.type = "profile"
    # facebook.expires_at = Time.current + 30.days
    facebook.save!

    ## based on this saved user account, get pages and store them
  end

  private
  def account_params
    params.require(:account).permit(:name, :image)
  end

  def facebook_params
    fb_params = account_params
    fb_params[:source] = 'facebook'
    fb_params[:status] = 'active'
  end
end

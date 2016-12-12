class AccountsController < ApplicationController
  require 'facebook'

  def create
    accounts = Facebook.create_accounts(
      params[:facebook_ids],
      params[:facebook_token],
      @current_user.team_id
    )

    Rails.logger.debug { accounts.inspect }

    ActiveRecord::Base.transaction do
      accounts.each do |account|
        account.save!
      end
    end
    render json: {accounts: @current_user.accounts}
  end
end

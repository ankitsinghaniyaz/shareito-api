class UsersController < ApplicationController
  require 'facebook'

  skip_before_action :authenticate_request!, only: [:create, :confirm, :login, :facebook_login]

  def create
    @user = User.new(user_params)
    @user.team = Team.new

    if @user.save
      # TODO: Send email for confirmation
      render json: {status: 'User created successfully'}, status: :created
    else
      render json: {errors: @user.errors.full_messages}, status: :bad_request
    end
  end

  def confirm
    token = params[:token].to_s
    user = User.find_by(confirmation_token: token)

    if user.present? && user.confirmation_token_valid?
      user.mark_as_confirmed!
      render json: {status: 'Email confirmed successfully'}, status: :ok
    else
      render json: {status: 'Email could not be verified'}, status: :not_found
    end
  end

  # POST login?email,password
  def login
    user = User.find_by(email: params[:email].to_s.downcase)

    # NOTE: authenticate mehtod is provided by has_secure_password bcrypt
    if user && user.authenticate(params[:password].to_s)
      if user.confirmed_at?
        auth_token = JsonWebToken.encode({user_id: user.id})
        render json: {auth_token: auth_token}, status: :ok
      else
        render json: {error: 'Email not verified'}, status: :unauthorized
      end
    else
      render json: {error: 'Invalid username or password'}, status: :unauthorized
    end
  end

  # POST facebook_login?token
  def facebook_login
    # Handles facebook login and signup
    profile = Facebook.profile(params[:token])

    if profile.nil?
      render json: {error: 'Could Not verify you with Facebook'}, status: :unauthorized
      return
    end

    @user = User.find_by(origin_user_id: profile["id"])

    if(@user)
      auth_token = JsonWebToken.encode({user_id: @user.id})
      render json: {auth_token: auth_token}, status: :ok
    else

      @user = User.new(facebook_user_params(profile))
      @user.team = Team.new
      if @user.save
        auth_token = JsonWebToken.encode({user_id: @user.id})
        render json: {auth_token: auth_token}, status: :created
      else
        render json: {errors: @user.errors.full_messages}, status: :bad_request
      end
    end
  end

  private
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def facebook_user_params(hash)
    password = SecureRandom.hex(10)
    result = {
      name: hash["name"],
      origin_user_id: hash["id"],
      email: hash["email"],
      password: password,
      password_confirmation: password
    }
    Rails.logger.debug { result.inspect }
    return result
  end
end

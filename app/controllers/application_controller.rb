class ApplicationController < ActionController::API
  require 'json_web_token'

  before_action :authenticate_request!

  protected
  # Validates current user and token and set @current_user scope
  def authenticate_request!
    if !payload || !JsonWebToken.valid_payload(payload.first)
      return invalid_authentication
    end

    load_current_user!
    invalid_authentication unless @current_user
  end

  # Return 401 response for malformed/invalid request
  def invalid_authentication
    render json: {error: 'Invalid Request'}, status: :unauthorized
  end

  private
  # Deconstructs the Authorization header and decode the JWT token
  def payload
    auth_token = request.headers['Authorization']
    token = auth_token.split(' ').last
    JsonWebToken.decode(token)
  rescue
    nil
  end

  # Sets the @current_user from user_id in payload
  def load_current_user!
    @current_user = User.find_by(id: payload[0]['user_id'])
  end
end

# frozen_string_literal: true

module ApiAuthenticable
  extend ActiveSupport::Concern
  include ActionController::HttpAuthentication::Token::ControllerMethods
  attr_reader :current_user

  private

  attr_writer :current_user

  def authenticate!
    authenticate_base
  end

  def authenticate_admin!
    authenticate_base admin: true
  end

  def authenticate_base(admin: false)
    authenticate_or_request_with_http_token do |token|
      api_key = find_api_key token

      if api_key && compare_token(token, api_key.token) && ((admin && api_key.user.is_admin) || !admin)
        @current_user = api_key.user
      end
    end
  end

  def find_api_key(token)
    return if token.nil?

    ApiKey.active_keys.find_by(token:)
  end

  def compare_token(token_received, api_key_token)
    ActiveSupport::SecurityUtils.secure_compare(token_received, api_key_token)
  end
end

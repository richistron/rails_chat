# frozen_string_literal: true

module ApiAuthenticable
  extend ActiveSupport::Concern
  include ActionController::HttpAuthentication::Token::ControllerMethods
  attr_reader :current_user

  private

  attr_writer :current_user

  def authenticate!
    authenticate_or_request_with_http_token do |token|
      return if token.nil?

      current_api_key = ApiKey.active_keys.find_by(token:)
      if current_api_key && ActiveSupport::SecurityUtils.secure_compare(token, current_api_key.token)
        @current_user = @current_api_key.user
      end
    end
  end
end

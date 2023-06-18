# frozen_string_literal: true

class AuthController < ApplicationController
  before_action :find_user, only: :login

  def login
    return invalid_login_response unless @user.authenticate login_params[:password]

    create_and_destroy_expired
    render status: :ok, json: serialize(active_api_keys.first)
  end

  private

  def login_params
    params.permit(:username, :password)
  end

  def create_and_destroy_expired
    expired_keys.destroy_all

    @user.api_keys.create! if active_api_keys.count.zero?
  end

  def expired_keys
    @expired_keys ||= @user.api_keys.expired_keys
  end

  def active_api_keys
    @active_api_keys ||= @user.api_keys.active_keys
  end

  def find_user
    @user ||= User.find_by! username: login_params[:username]
  rescue StandardError
    invalid_login_response
  end

  def invalid_login_response
    render status: :bad_request, json: { error: 'invalid username/password combination' }
  end

  def serialize(api_key)
    api_key.as_json only: %i[token expiration]
  end
end

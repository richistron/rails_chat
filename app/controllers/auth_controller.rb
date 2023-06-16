# frozen_string_literal: true

class AuthController < ApplicationController
  before_action :find_user, only: :login

  def login
    return invalid_login_response unless @user.authenticate login_params[:password]

    render status: :ok, json: serialize(@user)
  end

  private

  def login_params
    params.permit(:username, :password)
  end

  def find_user
    @user ||= User.find_by! username: login_params[:username]
  rescue StandardError
    invalid_login_response
  end

  def invalid_login_response
    render status: :bad_request, json: { error: 'invalid username/password combination' }
  end

  def serialize(user)
    user.as_json only: %i[uuid username]
  end
end

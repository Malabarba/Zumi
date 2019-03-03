# frozen_string_literal: true

class Api::V1::SessionsController < Api::V1::ApiController
  def create
    session_params = params.require(:user)
    @user = User.find_for_authentication(email: session_params.require(:email))
    raise ActiveRecord::RecordNotFound unless @user.present?

    @user.validate_password!(session_params.require(:password))
    sign_in(@user)
    j user: @user
  end

  def delete
    sign_out(:user)
  end
end

class Api::V1::MeController < Api::V1::ApiController
  def show
    j user: current_user
  end

  def create
    @user = User.permitted_create!(params)
    sign_in(@user)
    j user: @user
  end

  def update
    j user: current_user!.permitted_update!(params)
  end

  def update_password
    current_password = params.require(:user).require(:current_password)
    (@user = current_user!).validate_password!(current_password)
    j user: @user.update!(password: params.require(:user).require(:new_password))
  end
end

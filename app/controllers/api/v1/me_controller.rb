class Api::V1::MeController < Api::V1::ApiController
  def show
    j user: current_user
  end

  def create
    @user = User.create!(user_params(:create))
    sign_in(@user)
    j user: @user
  end

  def update
    j user: current_user!.update!(user_params(:update))
  end

  def update_password
    current_password = params.require(:user).require(:current_password)
    (@user = current_user!).validate_password!(current_password)
    j user: @user.update!(password: params.require(:user).require(:new_password))
  end

  private

  def user_params(action)
    params.require(:user).permit(User.permitted_params(action))
  end
end

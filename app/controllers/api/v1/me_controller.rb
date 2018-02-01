class Api::V1::MeController < Api::V1::ApiController
  def show
    render(json: { user: current_user!.as_json })
  end

  def create
    if (@user = User.new(user_params(:create))).save
      sign_in(@user)
      render(json: { user: @user.as_json })
    else
      render(json: { errors: @user.errors.messages }, status: 422)
    end
  end

  def update
    if (@user = current_user!).update(user_params(:update))
      render(json: { user: @user.as_json })
    else
      render(json: { errors: @user.errors.messages }, status: 422)
    end
  end

  def update_password
    current_password = params.require(:user).require(:current_password)
    if (@user = current_user!).valid_password?(current_password)
      if @user.update(password: params.require(:user).require(:new_password))
        render(json: { user: @user.as_json })
      else
        render(json: { errors: @user.errors.messages }, status: 422)
      end
    else
      unauthorized
    end
  end

  private

  def user_params(action)
    permitted = %i(email first_name surname phone birth_date)
    permitted += %i(cpf password) if action == :create
    params.require(:user).permit(*permitted)
  end
end

class Api::V1::MeController < Api::V1::ApiController
  def show
    render(json: { user: current_user.as_json })
  end

  def create
    if (@user = User.new(user_params)).save
      sign_in(@user)
      render(json: { user: @user.as_json })
    else
      render(json: { errors: @user.errors.messages }, status: 422)
    end
  end

  def update
    if (@user = current_user).update(user_params)
      render(json: { user: @user.as_json })
    else
      render(json: { errors: @user.errors.messages }, status: 422)
    end
  end

  private

  def user_params(action)
    permitted = %i(email password first_name surname phone birth_date)
    permitted << :cpf if action == :create
    params.require(:user).permit(*permitted)
  end
end

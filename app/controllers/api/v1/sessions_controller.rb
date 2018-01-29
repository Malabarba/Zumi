class Api::V1::SessionsController < Api::V1::ApiController
  skip_before_action :verify_authenticity_token

  def create
    session_params = params.require(:user).permit(:email, :password)
    @user = User.find_for_authentication(email: session_params[:email])
    if @user.present?
      if @user.valid_password?(session_params[:password])
        sign_in(@user)
        render(json: { user: @user.as_json })
      else
        unauthorized
      end
    else
      render(json: { message: 'User not found' }, status: 404)
    end
  end

  def delete
    sign_out(:user)
    head :no_content
  end
end

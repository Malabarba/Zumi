class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :set_paper_trail_whodunnit

  def authenticate_admin_user!
    authenticate_user!
    return if current_user&.admin?
    Rails.logger.error("#{current_user.inspect} tried to authenticate as admin")
    raise SecurityError
  end

  rescue_from SecurityError do |exception|
    redirect_to root_url
  end
end

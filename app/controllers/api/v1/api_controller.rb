class Api::V1::ApiController < ApplicationController
  skip_before_action :verify_authenticity_token

  include ::Rescuable

  private

  def current_user!
    current_user || (raise ActiveRecord::RecordNotFound)
  end
end

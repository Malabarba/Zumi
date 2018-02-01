class Api::V1::PropertiesController < Api::V1::ApiController
  before_action :ensure_user_is_seller, except: :create

  def index
    j properties: scope
  end

  def show
    j property: find_property
  end

  private

  def ensure_user_is_seller
    raise ActiveRecord::RecordNotFound unless current_user&.seller?
  end

  def scope
    current_user!&.properties.includes(:address)
  end

  # Use callbacks to share common setup or constraints between actions.
  def find_property
    @property ||= scope.find(params[:id])
  end
end

class Api::V1::PropertiesController < Api::V1::ApiController
  before_action :ensure_user_is_seller

  def index
    render json: { properties: scope.as_json(shallow: true) }
  end

  def show
    if current_user &&
       find_property.owner == current_user
      render json: { property: @property.as_json }
    else
      not_found
    end
  end

  private

  def ensure_user_is_seller
    raise ActiveRecord::RecordNotFound unless current_user&.seller?
  end

  def scope
    Property.includes(:address).where(owner_id: current_user.id)
  end

  # Use callbacks to share common setup or constraints between actions.
  def find_property
    @property ||= scope.find(params[:id])
  end
end

class Api::V1::ListingsController < Api::V1::ApiController
  def index
    render json: { listings: scope.as_json(shallow: true) }
  end

  def show
    if find_listing.published?
      render json: { listing: @listing.as_json }
    else
      not_found
    end
  end

  private

  def scope
    Listing.includes(property: :address).published
  end

  # Use callbacks to share common setup or constraints between actions.
  def find_listing
    @listing ||= scope.find(params[:id])
  end
end

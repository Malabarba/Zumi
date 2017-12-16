class SaleListingsController < ApplicationController
  # GET /sale_listings
  # GET /sale_listings.json
  def index
    @sale_listings = SaleListing.all
  end

  # GET /sale_listings/1
  # GET /sale_listings/1.json
  def show
    set_sale_listing
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_sale_listing
    @sale_listing = SaleListing.find(params[:id])
  end
end

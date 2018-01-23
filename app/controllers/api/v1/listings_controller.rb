class Api::V1::ListingsController < Api::V1::ApiController
  PER_PAGE = 30

  def index
    page = params[:page].to_i
    search = scope.ransack(**search_opts, m: 'a')
    search.sorts = 'published_at desc' if search.sorts.empty?
    search = search.result
                   .limit(PER_PAGE)
                   .offset(page * PER_PAGE)
    render json: { count: search.count,
                   listings: search.as_json(shallow: true) }
  end

  def neighborhoods
    @neighborhoods = Address.order(:neighborhood).group(:neighborhood).count
    render json: { neighborhoods: @neighborhoods }
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
    Listing.includes(property: [:address, :photos]).published
  end

  # Use callbacks to share common setup or constraints between actions.
  def find_listing
    @listing ||= scope.find_by(uniq_hash: params[:id])
  end

  PROPERTY_FILTERS = (
    %i(furnished_true furnished_false neighborhood_in neighborhood_eq) +
    %i(toilet_count bath_count bedroom_count lot_size_m2 usable_size_m2 price_cents)
      .flat_map { |f| [:"#{f}_gteq", :"#{f}_lteq"] }
  ).freeze
  def search_opts
    return {} unless (q = params[:q])
    q.permit(:s, *PROPERTY_FILTERS).to_h.symbolize_keys
  end
end

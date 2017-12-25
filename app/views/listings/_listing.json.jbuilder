json.extract! listing, :id, :property, :type, :price_cents, :minimum_down_payment_cents, :furnished, :created_at, :updated_at
json.url listing_url(listing, format: :json)

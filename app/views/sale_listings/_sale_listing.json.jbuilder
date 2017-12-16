json.extract! sale_listing, :id, :property, :type, :price_cents, :minimum_down_payment_cents, :furnished, :created_at, :updated_at
json.url sale_listing_url(sale_listing, format: :json)

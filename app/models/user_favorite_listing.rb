class UserFavoriteListing < ApplicationRecord
  belongs_to :listing
  belongs_to :user, inverse_of: :user_favorite_listings
end

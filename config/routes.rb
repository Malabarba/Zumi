Rails.application.routes.draw do
  devise_for :users

  ActiveAdmin.routes(self)
  root to: 'sale_listings#index'
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      get 'me', to: 'me#show'
      get 'sale_listings', to: 'sale_listings#index'
      post 'sale_listings', to: 'sale_listings#create'
      get 'sale_listings/:id', to: 'sale_listings#show'
    end
  end
end
# For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

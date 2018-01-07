Rails.application.routes.draw do
  devise_for :users

  ActiveAdmin.routes(self)

  # root to: 'listings#index'
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      get 'me', to: 'me#show'

      get 'listings', to: 'listings#index'
      get 'listings/:id', to: 'listings#show'

      get 'properties', to: 'properties#index'
      get 'properties/:id', to: 'properties#show'
    end
  end
end
# For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

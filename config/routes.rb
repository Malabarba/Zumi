Rails.application.routes.draw do
  devise_for :users

  ActiveAdmin.routes(self)

  # root to: 'listings#index'
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      get 'listings', to: 'listings#index'
      get 'listings/neighborhoods', to: 'listings#neighborhoods'
      get 'listing/:id', to: 'listings#show'

      get 'properties', to: 'properties#index'
      get 'property/:id', to: 'properties#show'

      post 'sessions', to: 'sessions#create'
      delete 'sessions', to: 'sessions#delete'

      post 'me', to: 'me#create'
      get 'me', to: 'me#show'
      patch 'me', to: 'me#update'
      patch 'me/password', to: 'me#update_password'
      # delete 'users', to: 'users#delete'
    end
  end

  get '*a', to: 'static#index_file'
  get '*a/*b', to: 'static#index_file'
  get '*a/*b/*c', to: 'static#index_file'
end
# For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

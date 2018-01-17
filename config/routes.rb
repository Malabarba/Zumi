Rails.application.routes.draw do
  devise_for :users

  ActiveAdmin.routes(self)

  # root to: 'listings#index'
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      get 'me', to: 'me#show'

      get 'listings', to: 'listings#index'
      get 'listings/neighborhoods', to: 'listings#neighborhoods'
      get 'listing/:id', to: 'listings#show'

      get 'properties', to: 'properties#index'
      get 'property/:id', to: 'properties#show'
    end
  end

  get '*', to: 'static#html_file'
end
# For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

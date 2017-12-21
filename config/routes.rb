Rails.application.routes.draw do
  devise_for :users

  ActiveAdmin.routes(self)
  root to: 'sale_listings#index'
  resources :sale_listings
end
# For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

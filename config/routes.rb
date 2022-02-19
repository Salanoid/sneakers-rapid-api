Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: 'sneakers#index'

  get '/releases/all_releases', to: 'sneakers#all_releases', as: 'all_releases'
  get '/releases/:month', to: 'sneakers#monthly_releases', as: 'monthly_releases' 
end
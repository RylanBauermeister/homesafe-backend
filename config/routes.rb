Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      resources :users, only: [:update]
      resources :crimes, only: [:index]
      resources :avoids, only: [:index, :create, :destroy]
      resources :reports, only: [:index, :create, :destroy]
      post 'my_profile', to: 'users#my_profile'
    end
  end
end

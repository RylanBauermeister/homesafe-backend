Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      resources :crimes, only: [:index]
      post 'my_profile', to: 'users#my_profile'
    end
  end
end

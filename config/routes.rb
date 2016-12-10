Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'application#angular'
  resources :issues, only: [:index, :show] do
    post 'report', :on => :collection
  end
  resources :instances, only: [:index, :show]
  resources :builds, only: [:index, :show]
end

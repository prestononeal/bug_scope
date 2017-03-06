Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :issues, only: [:index, :show, :update] do
    post 'report', :on => :collection
    get 'similar_to', :on => :member
    put 'merge_to', :on => :member
  end
  resources :instances, only: [:index, :show]
  resources :builds, only: [:index, :show]

  get '/ui' => 'ui#index'
  get '/ui#' => 'ui#index'
  root to: 'ui#index'
end

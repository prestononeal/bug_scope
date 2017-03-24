Rails.application.routes.draw do
  scope :api, defaults: {format: :json} do
    resources :issues, only: [:index, :show, :update] do
      post 'report', :on => :collection
      get 'similar_to', :on => :member
      put 'merge_to', :on => :member
    end
    resources :instances, only: [:index, :show]
    resources :builds, only: [:index, :show]
  end

  root :to => 'ui#index'

  get '*unmatched_route', to: 'ui#index'
end

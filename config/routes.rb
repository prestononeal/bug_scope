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

  get "/client-assets/:name.:format", :to => redirect("/client/client-assets/%{name}.%{format}")
  get "/", :to => redirect("/client/index.html")
end

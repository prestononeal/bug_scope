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

  # TODO: change to `/?goto=%{path}` when we can handle dynamic routing in Angular2
  get "/*path" => redirect("/")
end

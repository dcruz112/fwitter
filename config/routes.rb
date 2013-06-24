Project1::Application.routes.draw do
  root to: 'users#index'

  get '/log_in' => 'sessions#log_in', as: :log_in
  get '/log_out' => 'sessions#log_out', as: :log_out

  # namespace :users, :module => "relationships" do
  #   resources :following, :followers
  # end

  # try following/users/1 instead?

  # The "namespace" thing they keep talking about in routes is important

  # scope "/users/:id/following" do
  #   resources :relationships
  # end

  resources :tweets
  resources :relationships
  resources :users do
    member do
      get :following, :followers
    end 
  end

  # We'll want to add a follow route at some point, I suppose? 
    # And eventually implement Ajax for auto-following


  # We want to use member rather than collection stuff, because there doesn't
  # seem to be a point to seeing all followers in the DB -- maybe for admin?

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end

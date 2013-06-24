Project1::Application.routes.draw do
  root to: 'users#show'

  get '/log_in' => 'sessions#log_in', as: :log_in
  get '/log_out' => 'sessions#log_out', as: :log_out
  get '/follow/:id' => 'users#follow', as: :follow
  get '/default/:id' => 'users#default', as: :default
  get '/show_stuff' => 'users#show_stuff', as: :show_stuff
  get '/retweet/:id' => 'tweets#retweet', as: :retweet
  get '/tweets/:id/retweet' => 'tweets#retweet'



  #resources :tweets

  resources :tweets do
    member do
      get 'retweet'
    end
  end

  resources :users do
    member do
      get 'follow'
    end
  end

  # We'll want to add a follow route at some point, I suppose?
    # And eventually implement Ajax for auto-following

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

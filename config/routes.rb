Project1::Application.routes.draw do
  

  root to: 'users#show'


  get '/log_in' => 'sessions#log_in', as: :log_in
  get '/log_out' => 'sessions#log_out', as: :log_out
  get '/default/:id' => 'users#default', as: :default
  get '/switch_user/:id' => 'users#switch_user', as: :switch_user
  get '/show_stuff' => 'users#show_stuff', as: :show_stuff



  # get '/retweet/:id' => 'retweets#show'
  # get '/retweets' => 'retweets#new', as: :new_retweet
  # post '/retweets' => 'retweets#create', as: :retweet
  # delete '/retweets/:id' => 'retweets#destroy'
  # patch '/retweets/:id' => 'retweets#update'
  # put '/retweets/:id' => 'retweets#update'
  # get '/retweets' => 'retweets#index', as: :retweets


  resources :tweets do
    member do
      get :favorite
    end
  end

  resources :retweets


  resources :relationships

  resources :users do
    member do
      get :following, :followers, :favorites, :mentions
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
end

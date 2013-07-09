Project1::Application.routes.draw do

  root to: 'users#show'

  get '/log_in' => 'sessions#log_in', as: :log_in
  get '/log_out' => 'sessions#log_out', as: :log_out
  get '/default/:id' => 'users#default', as: :default
  get '/switch_user/:id' => 'users#switch_user', as: :switch_user
  get '/show_stuff' => 'users#show_stuff', as: :show_stuff
  get 'tweets/:id/reply' => 'tweets#new', as: :new
  get '/hashes/:hash_word' => 'tweets#hashes', as: :hash
  get '/users/edit' => 'users#edit'

  resources :tweets do
    member do
      get :favorite, :hashes, :reply
    end
  end

  resources :users do
    member do
      get :following, :followers, :favorites, :notifications
    end 
  end

  resources :retweets

  resources :relationships

  resources :conversations

end

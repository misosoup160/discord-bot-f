Rails.application.routes.draw do
  namespace :admin do
    resources :users, only: %i(index update)
  end
  root 'welcom#index'
  get '/auth/:provider/callback' => 'sessions#create'
  delete '/logout' => 'sessions#destroy'
end

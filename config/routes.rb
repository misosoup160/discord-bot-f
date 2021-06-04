Rails.application.routes.draw do
  root 'welcom#index'
  get '/auth/:provider/callback' => 'sessions#create'
  delete '/logout' => 'sessions#destroy'

  namespace :admin do
    resources :users, only: %i(index update)
    resources :questions
  end

  resources :answers, only: %i(index new create)
end

Rails.application.routes.draw do
  root to: 'answers#new'
  get 'welcom', to: 'welcom#index', as: 'welcom'
  get '/auth/:provider/callback' => 'sessions#create'
  delete '/logout' => 'sessions#destroy'

  namespace :admin do
    resources :users, only: %i(index update)
    resources :questions
  end

  resources :users, only: %i() do
    resources :answers, only: %i(index), controller: 'users/answers'
  end

  resources :answers
end

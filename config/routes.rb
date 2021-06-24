Rails.application.routes.draw do
  root to: 'answers#new'
  get 'welcome', to: 'welcome#index', as: 'welcome'
  get '/auth/:provider/callback' => 'sessions#create'
  delete '/logout' => 'sessions#destroy'

  namespace :admin do
    resources :users, only: %i(index update)
    resources :questions
    get 'users/search' => 'users#search'
  end

  namespace :me do
    resources :answers, only: %i(index)
  end

  get 'answers/search' => 'answers#search'
  resources :answers
end

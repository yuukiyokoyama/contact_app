Rails.application.routes.draw do
  root   'static_pages#home'
  get    '/help',    to: 'static_pages#help'
  get    '/about',   to: 'static_pages#about'
  get    '/contact', to: 'static_pages#contact'
  get    '/signup',  to: 'users#new'
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'
  resources :users do
    member do
      get :following, :followers
    end
  end
  resources :users do
    member do
      get :following, :followers , :likes
    end
  end
  resources :talk,  only: [:show, :create]do
    member do
      post :memberships, :messages
    end
  end
  resources :users
  resources :microposts,          only: [:create, :destroy]
  resources :relationships,       only: [:create, :destroy]
  resources :favorite_relationships, only: [:create, :destroy]
  mount ActionCable.server => '/cable'
  resources :memberships, only: :destroy
  resources :messages,    only: :destroy
  resources :likes, only: [:create, :destroy]
  resources :password_resets,     only: [:new, :create, :edit, :update]
end

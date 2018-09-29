Rails.application.routes.draw do
  mount ForestLiana::Engine => '/forest'
  devise_for :users
  root to: 'pages#home'
  get '/apps/favorite', to: 'apps#favorite', as: 'favorite_apps'
  get '/apps/shared/:public_token', to: 'apps#shared_apps'
  get '/bookmarks/create_multiple', to: 'bookmarks#create_multiple', as: 'create_multiple_bookmarks'
  resources :apps, only: [:index, :show, :new, :create] do
    resources :bookmarks, only: [:create]
    resources :reviews, only: [:create ]
  end
  resources :bookmarks, only: [:destroy]
  get 'apps/:app_id/bookmark', to: 'bookmarks#create', as: "bookmarkerr"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # Google Authentication
  get '/google_oauth2/get_google_access_code', to: 'google_authentications#get_google_access_code'
  get '/google_oauth2/callback', to: 'google_authentications#callback'
end

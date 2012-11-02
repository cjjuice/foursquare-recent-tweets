FoursquareRecentTweet::Application.routes.draw do
  resources :pages

  match 'auth/:provider/callback', to: 'users#create'
  match 'auth/failure', to: redirect('/')
  match 'push', to: 'checkins#push'
  match 'success', to: 'pages#success'

  root to: 'pages#index'
end                 

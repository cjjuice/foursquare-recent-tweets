FoursquareRecentTweet::Application.routes.draw do
  match 'auth/:provider/callback', to: 'users#create'
  match 'auth/failure', to: redirect('/')
  match 'push', to: 'checkins#push'
end                 

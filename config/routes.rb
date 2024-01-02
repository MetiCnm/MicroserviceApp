Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
  #
  # Authentication routes
  get '/login' => 'sessions#new'
  post '/login' =>'sessions#create'
  get '/signup' => 'registrations#new'
  post '/signup' => 'registrations#create'
  delete '/logout' => 'sessions#destroy'

  # User routes
  resources :users, only:[:show, :update, :edit] do
    get 'vehicles', on: :member
    get 'fines', on: :member
  end

  # Notification routes
  resources :notifications do
    patch 'publish', on: :member
    get 'json', on: :member, to: 'notifications#show_json', defaults: {format: 'json'}
    get 'json', on: :collection, to: 'notifications#index_json', defaults: {format: 'json'}
    get 'xml', on: :member, to: 'notifications#show_xml', defaults: {format: 'xml'}
    get 'xml', on: :collection, to: 'notifications#index_xml', defaults: {format: 'xml'}
  end
  get '/main' => 'notifications#main'

  # Vehicle routes
  resources :vehicles

  # Fine routes
  resources :fines do
    get 'payment', on: :member, to: 'payments#new'
    post 'payment', on: :member, to: 'payments#create'
    post 'payment_json', on: :member, to: 'payments#create_json'
    get 'json', on: :member, to: 'fines#show_json', defaults: {format: 'json'}
    get 'json', on: :collection, to: 'fines#index_json', defaults: {format: 'json'}
    get 'xml', on: :member, to: 'fines#show_xml', defaults: {format: 'xml'}
    get 'xml', on: :collection, to: 'fines#index_xml', defaults: {format: 'xml'}
  end

end

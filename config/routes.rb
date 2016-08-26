Rails.application.routes.draw do
  # root 'welcome#index'
  #
  root 'authentication#new'
  resources :authentication, :welcome
  post 'welcome/verify'
  get '/:hash_url', to: 'welcome#index', as: 'viewed_video'

  #
  # get 'authentication/show'
  #
  # get 'welcome/start_page'
  # get 'welcome/start'
  # #get 'welcome/start'
  #
  # post 'welcome/verify'
  #
  # post 'welcome/video', to: 'welcome#video'
  # post 'welcome/upload', to: 'welcome#upload'
  # #post 'welcome/welcome/upload'
  # resources :signed_url, only: :index
  #

  # root 'welcome/'
end

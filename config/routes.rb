Rails.application.routes.draw do
  root 'welcome#index'

  get 'welcome/start_page'
  get 'welcome/start'


  post 'welcome/video', to: 'welcome#video'
  get '/:hash_url', to: 'welcome#index', as: 'viewed_video'
  post 'welcome/upload', to: 'welcome#upload'

  resources :signed_url, only: :index


end

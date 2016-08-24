Rails.application.routes.draw do
  root 'welcome#index'

  post 'welcome/video', to: 'welcome#video'
  get '/:hash_url', to: 'welcome#index', as: 'viewed_video'
  post 'welcome/upload', to: 'welcome#upload'

  resources :signed_url, only: :index
  resources :pictures, :only => [:index, :create, :destroy]

end

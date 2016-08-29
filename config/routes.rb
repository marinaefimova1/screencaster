Rails.application.routes.draw do
  get 'videos/show'
  get 'videos/verify'
  get '/:hash_url', to: 'videos#show', as: 'viewed_video'
  post 'videos/upload', to: 'videos#upload'


  root 'authentications#new'

  resource :authentications, only: [:show, :new] do
    get :authenticate, on: :member
  end
  # resource :videos, only: [:show, :upload, :verify] do
  #   get 'show'
  #     get '/:hash_url', to: 'videos#show', as: 'viewed_video', on: :member
  #     post 'upload', to: 'videos#upload'
  #     post 'verify', on: :member
  #   end


  # get 'welcome/start_page'
  # get 'welcome/start'
  # post 'welcome/verify'
  # post 'welcome/video', to: 'welcome#video'
  # post 'welcome/upload', to: 'welcome#upload'
  # #post 'welcome/welcome/upload'

end

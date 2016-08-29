Rails.application.routes.draw do
  root 'authentications#new'

  resource :authentications, only: [:show, :new] do
    get :authenticate, on: :member
  end
  resources :welcome
  get '/:hash_url', to: 'welcome#index', as: 'viewed_video'

  # get 'welcome/start_page'
  # get 'welcome/start'
  # post 'welcome/verify'
  # post 'welcome/video', to: 'welcome#video'
  # post 'welcome/upload', to: 'welcome#upload'
  # #post 'welcome/welcome/upload'

end

Rails.application.routes.draw do
  root to: 'jobs#index'

  resources :jobs, only: [:index, :new, :create]

  resource :jobs do
    resource :preview, only: [:show]
    resource :summary, only: [:show]
  end
end

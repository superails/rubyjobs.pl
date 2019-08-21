Rails.application.routes.draw do
  root to: 'jobs#index'

  resources :jobs, only: [:index, :new, :create]

  namespace :jobs do 
    resource :preview, only: [:show]
    resource :summary, only: [:show]
    resource :publication, only: [:create]
  end
end

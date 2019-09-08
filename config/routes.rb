Rails.application.routes.draw do
  root to: 'jobs#index'

  namespace :jobs do 
    resource :preview, only: [:show]
    resource :summary, only: [:show]
    resource :publication, only: [:create]
  end

  resources :jobs, only: [:index, :show, :new, :create]
end

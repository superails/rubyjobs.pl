Rails.application.routes.draw do
  get 'jobs/index'
  get 'jobs/new'
  resources :jobs, only: [:index, :new]
  root to: 'jobs#index'
end

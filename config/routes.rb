Rails.application.routes.draw do
  devise_for :users
  root to: 'job_offers#index'

  namespace :job_offers, path: 'jobs' do 
    resource :preview, only: [:show]
    resource :summary, only: [:show]
    resource :submission, only: [:create]
  end

  resources :jobs, only: [:index, :show, :new, :create], controller: 'job_offers', as: 'job_offers'
end

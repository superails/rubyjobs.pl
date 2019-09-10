Rails.application.routes.draw do
  root to: 'job_offers#index'

  namespace :job_offers, path: 'jobs' do 
    resource :preview, only: [:show]
    resource :summary, only: [:show]
    resource :publication, only: [:create]
  end

  resources :jobs, only: [:index, :show, :new, :create], controller: 'job_offers', as: 'job_offers'
end

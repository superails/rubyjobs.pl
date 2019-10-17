require 'sidekiq/web'

Rails.application.routes.draw do
  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  devise_for :users

  root to: 'job_offers#index'

  namespace :job_offers, path: 'jobs' do 
    resource :preview, only: [:show]
    resource :summary, only: [:show]
    resources :submissions, only: [:create, :destroy], param: :job_offer_id
    resources :publications, only: [:create], param: :job_offer_id
  end

  resources :jobs, only: [:index, :show, :new, :create], controller: 'job_offers', as: 'job_offers'
end

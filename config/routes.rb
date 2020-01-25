require 'sidekiq/web'

Rails.application.routes.draw do
  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  devise_for :users

  root to: 'job_offers#index'

  namespace :job_offers, path: 'jobs' do 
    resources :redirects, only: [:show]
    resources :previews, only: [:show], param: :token
    resources :summaries, only: [:show], param: :token
    resources :submissions, only: [:create, :destroy], param: :token
    resources :publications, only: [:create], param: :token
  end

  resources :jobs, except: [:destroy, :show], controller: 'job_offers', as: 'job_offers', param: :token
  resources :jobs, only: [:show], controller: 'job_offers', as: 'job_offers'
  resources :newsletter_subscriptions, only: [:create]

  get 'newsletter_subscriptions/:confirm_token/confirm', to: 'newsletter_subscriptions/confirmations#create', as: 'newsletter_subscription_confirmation'
end

require 'sidekiq/web'

Rails.application.routes.draw do
  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  use_doorkeeper
  devise_for :users
  root to: 'questions#index'
  
  concern :votable do
    member do
      post :vote_up
      post :vote_down
      delete :unvote
    end
  end

  resources :questions, shallow: true, except: %i[ edit ], concerns: :votable do
    resources :answers, except: %i[index show new edit], concerns: :votable do
      member do
        patch :best
      end
      resources :comments, only: %i[ create update destroy ]
    end
    resources :comments, only: %i[ create update destroy ]
    resources :subscriptions, only: %i[ create destroy ]
  end

  resources :attachments, only: %i[ destroy ]
  resources :links, only: %i[ destroy ]

  namespace :api do
    namespace :v1 do
      resources :profiles, only: [ :index ] do
        get :me, on: :collection
      end

      resources :questions, only: [ :index, :show, :create, :update, :destroy ] do
        resources :answers, only: [ :index, :show, :create, :update, :destroy ], shallow: true
      end
    end
  end

  mount ActionCable.server => '/cable'
end

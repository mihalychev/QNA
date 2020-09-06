Rails.application.routes.draw do
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
      resources :comments, only: %i[ create ]
    end
    resources :comments, only: %i[ create ]
  end

  resources :attachments, only: %i[ destroy ]
  resources :links, only: %i[ destroy ]
  resources :rewards, only: %i[ index ]

  namespace :api do
    namespace :v1 do
      resources :profiles, only: [ :index ] do
        get :me, on: :collection
      end

      resources :questions, only: [:index]
    end
  end

  mount ActionCable.server => '/cable'
end

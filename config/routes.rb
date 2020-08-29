Rails.application.routes.draw do
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
    end
  end

  resources :attachments, only: %i[ destroy ]
  resources :links, only: %i[ destroy ]
  resources :rewards, only: %i[ index ]

  mount ActionCable.server => '/cable'
end

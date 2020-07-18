Rails.application.routes.draw do
  resources :questions, shallow: true do
    resources :answers, except: %i[index show]
  end
end

Rails.application.routes.draw do
  devise_for :users

  get "up" => "rails/health#show", as: :rails_health_check

  resources :articles do
    member do
      post :report
    end
  end

  root "articles#index"
end

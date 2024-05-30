# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      mount_devise_token_auth_for 'User', at: 'users', controllers: {
        registrations: 'api/v1/users/registrations',
        confirmations: 'api/v1/users/confirmations',
        sessions: 'api/v1/users/sessions'
      }

      resources :tweets, only: %i[index create show] do
        resources :images, only: %i[create]
      end
    end
  end

  resources :tasks

  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end

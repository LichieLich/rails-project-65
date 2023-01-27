# frozen_string_literal: true

Rails.application.routes.draw do
  scope module: :web do
    post 'auth/:provider', to: 'auth#request', as: :auth_request
    get 'auth/:provider/callback', to: 'auth#callback', as: :callback_auth
    get 'auth/logout', to: 'auth#logout'

    resources :bulletins, only: %i[new create destroy show edit update]

    resources :categories, only: %i[new create destroy]

    root 'home#index'
  end
end

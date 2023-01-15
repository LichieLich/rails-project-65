# frozen_string_literal: true

Rails.application.routes.draw do
  scope module: :web do
    post 'auth/github', to: 'auth#request', as: :auth_request
    get 'auth/github/callback', to: 'auth#callback', as: :callback_auth

    root 'home#index'
  end
end

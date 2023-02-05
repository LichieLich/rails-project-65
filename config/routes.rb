# frozen_string_literal: true

Rails.application.routes.draw do
  scope module: :web do
    post 'auth/:provider', to: 'auth#request', as: :auth_request
    get 'auth/:provider/callback', to: 'auth#callback', as: :callback_auth
    get 'auth/logout', to: 'auth#logout'

    resources :bulletins, only: %i[index new create destroy show edit update]

    scope :admin, as: 'admin' do
      resources :categories, only: %i[index new create destroy edit update]
      resources :bulletins, only: %i[show]
      get 'bulletins', to: 'bulletins#admin_index'
    end

    root 'bulletins#index'
  end
end

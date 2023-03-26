# frozen_string_literal: true

Rails.application.routes.draw do
  scope module: :web do
    post 'auth/:provider', to: 'auth#request', as: :auth_request
    get 'auth/:provider/callback', to: 'auth#callback', as: :callback_auth
    get 'auth/logout', to: 'auth#logout'

    resources :bulletins, only: %i[index new create destroy show edit update] do
      member do
        patch :archive
        patch :send_to_moderation, as: 'moderation'
      end
    end
    get 'profile', to: 'bulletins#profile'

    namespace :admin, as: 'admin' do
      resources :categories, only: %i[index new create destroy edit update]
      resources :bulletins, only: %i[show admin_index] do
        member do
          patch :publish
          patch :reject
          patch :archive
        end
      end
      get 'bulletins', to: 'bulletins#admin_index'
      get '/', to: 'bulletins#bulletins_under_moderation'
    end

    root 'bulletins#index'
  end
end

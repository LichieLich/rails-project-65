# frozen_string_literal: true

module Web
  class AuthController < Web::ApplicationController
    def callback
      @user_info = request.env['omniauth.auth']
      user = User.find_by(email: @user_info['info']['email'])
      create_user unless user
      session[:user_id] = user.id
      redirect_to :root
    end

    def create_user
      User.create(name: @user_info['info']['nickname'], email: @user_info['info']['email'])
    end

    def logout
      session[:user_id] = nil
      redirect_to :root
    end
  end
end

# frozen_string_literal: true

module Web
  class AuthController < Web::ApplicationController
    def callback
      @user_info = request.env['omniauth.auth']
      session[:user_id] = @user_info['uid']
      create_user unless User.find_by(id: session[:user_id])
      redirect_to :root
    end

    def create_user
      User.create(name: @user_info['info']['nickname'], email: @user_info['info']['email'], id: @user_info['uid'])
    end

    def logout
      session[:user_id] = nil
      redirect_to :root
    end
  end
end

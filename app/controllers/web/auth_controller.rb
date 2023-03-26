# frozen_string_literal: true

module Web
  class AuthController < Web::ApplicationController
    def callback
      @user_info = request.env['omniauth.auth']
      # binding.irb
      session[:user_email] = @user_info['info']['email']
      create_user unless User.find_by(email: session[:user_email])
      redirect_to :root
    end

    def create_user
      User.create(name: @user_info['info']['nickname'], email: @user_info['info']['email'])
    end

    def logout
      session[:user_email] = nil
      redirect_to :root
    end
  end
end

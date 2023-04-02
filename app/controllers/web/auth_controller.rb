# frozen_string_literal: true

module Web
  class AuthController < Web::ApplicationController
    def callback
      @user_info = request.env['omniauth.auth']

      session[:user_id] = User.find_or_create_by(email: @user_info['info']['email']) do |user|
        user.name = @user_info['info']['nickname']
        user.email = @user_info['info']['email']
      end.id

      redirect_to :root
    end

    def logout
      session[:user_id] = nil
      redirect_to :root
    end
  end
end

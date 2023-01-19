# frozen_string_literal: true

module Web
  class AuthController < Web::ApplicationController
    def request
    end

    def callback
      user_info = request.env['omniauth.auth']
      $user_info = user_info
    end
  end
end
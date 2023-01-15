# frozen_string_literal: true

module Web
  class AuthController < Web::ApplicationController
    def request
      binding.irb
      user_info = request.env['omniauth.auth']
      # raise user_info # Your own session management should be placed here.
      # binding.irb
    end

    def callback
      # binding.irb
    end
  end
end
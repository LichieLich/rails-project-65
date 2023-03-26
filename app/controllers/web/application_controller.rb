# frozen_string_literal: true

module Web
  class ApplicationController < ActionController::Base
    include Pundit::Authorization

    def current_user
      @current_user ||= User.find_by(email: session[:user_email])
    end
  end
end

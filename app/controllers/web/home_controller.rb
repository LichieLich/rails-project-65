# frozen_string_literal: true

module Web
  class HomeController < Web::ApplicationController
    def index
      @user = User.find_by(id: session[:user_id])
    end
  end
end

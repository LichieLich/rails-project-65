# frozen_string_literal: true

module Web
  class HomeController < Web::ApplicationController
    def index
      @user_info = $user_info
    end
  end
end
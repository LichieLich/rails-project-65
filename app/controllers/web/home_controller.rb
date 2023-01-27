# frozen_string_literal: true

module Web
  class HomeController < Web::ApplicationController
    def index
      @bulletins = Bulletin.all.order(created_at: :desc)
    end
  end
end

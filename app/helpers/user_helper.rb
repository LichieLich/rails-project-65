# frozen_string_literal: true

module UserHelper
  def current_user
    @current_user ||= User.find_by(email: session[:user_email])
  end
end

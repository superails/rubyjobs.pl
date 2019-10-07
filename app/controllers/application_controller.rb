class ApplicationController < ActionController::Base
  include Pundit

  def current_user
    super || GuestUser.new
  end
end

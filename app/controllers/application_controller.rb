class ApplicationController < ActionController::Base
  def current_user
    super || GuestUser.new
  end
end

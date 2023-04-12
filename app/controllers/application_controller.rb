class ApplicationController < ActionController::Base

  before_action :auth

  def auth
    http_basic_authenticate_or_request_with name: ENV["USERNAME"], password: ENV["PASSWORD"]
  end

end

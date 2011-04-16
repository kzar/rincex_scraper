class ApplicationController < ActionController::Base
  before_filter :authenticate
  protect_from_forgery

  protected

  def authenticate
    authenticate_or_request_with_http_basic do |username, password|
      username == APP_CONFIG['basic_auth_user'] && password == APP_CONFIG['basic_auth_password']
    end
  end
end

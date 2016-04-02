class Api::BaseController < ActionController::Base

  include ApiRendererHelper

  before_action :authenticate_client!
  before_action :authenticate_user!

  def authenticate_client!
    unless request.headers['X-CLIENT-TOKEN'] == API_CLIENT_TOKEN
      render_unauthorized
    end
  end

  def authenticate_user!
    render_unauthorized unless current_user
  end

  def current_user
    @current_user ||= User.find_by(device_token: request.headers['X-AUTH-TOKEN'])
  end
end

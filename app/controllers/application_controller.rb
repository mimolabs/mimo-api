class ApplicationController < ActionController::Base
  def after_sign_in_path_for(resource)
    if session[:return_to].present?
      session[:return_to]
    else
      "#{ENV['MIMO_DASHBOARD_URL']}/login"
    end
  end

  def cors_set_headers
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Allow-Methods'] = 'POST, DELETE, GET, OPTIONS, PATCH'
    headers['Access-Control-Request-Method'] = '*'
    headers['Access-Control-Allow-Headers'] = 'Origin,X-Requested-With,Content-Type,Accept,Authorization'
    headers['Access-Control-Max-Age'] = "1728000"
  end

  def cors_preflight_check
    return unless request.method == :options
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Allow-Methods'] = 'HEAD, POST, GET, OPTIONS, PATCH'
    headers['Access-Control-Allow-Headers'] = 'X-Requested-With,X-Prototype-Version'
    headers['Access-Control-Max-Age'] = '1728000'
    render :text => '', :content_type => 'text/plain'
  end
end

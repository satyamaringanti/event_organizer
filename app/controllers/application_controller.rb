class ApplicationController < ActionController::Base
  require 'event_exception'
  rescue_from EventException::ParamsMissing do |exception|
    error_response(nil, exception.info, exception.status)
  end
  def ensure_token
    unless token_valid?
      error_response(nil, 'Not Authorized', 412)
    end
  end

  def token_valid?
    request.headers[:token].present? ? request.headers[:token] == Rails.configuration.token : false
  end

  def required(params, *list)
    blank_params = list - list.reject {|x| params[x] == "" or params[x].nil? }
    if blank_params.empty?
      parameters = list.map {|x| params[x] }
      parameters.count == 1 ? parameters.first : parameters
    else
      raise EventException::ParamsMissing.new(info: "blank or missing params: #{blank_params.inspect}", status: 412)
    end
  end

  def error_response(data, message, status)
    render json: {body: data, message: message, status: status}
  end

  def success_response(data, message)
    data = data.is_a?(ActiveModel::Serializer) ? data.attributes : data
    render json: {data: data, message: message, status: 200}
  end
end

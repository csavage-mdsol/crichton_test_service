require 'hyper_error'

class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session

  respond_to :hale_json

  ERROR_CAUSE = { ActiveRecord::RecordNotFound => :not_found,
                  ActiveRecord::RecordInvalid  => :unprocessable_entity
                }

  rescue_from StandardError do |e|
    error_cause = ERROR_CAUSE[e.class] || :unprocessable_entity
    hyper_error = HyperError.new( title: e.class.to_s,
                                  details: e.message,
                                  error_code: error_cause,
                                  http_status: Rack::Utils.status_code(error_cause),
                                  stack_trace: e.backtrace.first,
                                  controller: self
                                )
    respond_with hyper_error, status: error_cause, location: hyper_error.describes_url
  end
end

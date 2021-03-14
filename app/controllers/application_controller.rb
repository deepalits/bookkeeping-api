class ApplicationController < ActionController::API
  include Pagy::Backend
  include ResponseHandler
  include ExceptionHandler
end

class Users::RegistrationsController < Devise::RegistrationsController
  include StoreCart

  before_action :configure_sign_up_params, only: [:create]
  before_action :configure_permitted_parameters, only: [:create]

  def new
    super
  end

  def create
    super
    store_cart_cookie_to_db
  end

  protected

  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:email, :password, :password_confirmation, :role])
  end
end

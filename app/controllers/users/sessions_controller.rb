class Users::SessionsController < Devise::SessionsController
  include StoreCart

  before_action :configure_sign_in_params, only: [:create]

  def new
    super
  end

  def create
    super
    set_flash_message(:notice, :signed_in) if is_navigational_format?
    store_cart_session_to_db
  end

  def destroy
    super
  end

  def configure_sign_in_params
    devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  end
end

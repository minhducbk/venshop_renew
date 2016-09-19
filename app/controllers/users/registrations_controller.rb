class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]
  before_action :configure_permitted_parameters, only: [:create]
  # before_action :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  def new
    super
  end

  # POST /resource
  def create
    super

    if current_user.role == User.role_users[:customer]
      cart = current_user.cart
      cart = Cart.create(user_id: current_user.id) if cart.blank?
      if cookies[:cart].present?
        list_items = JSON.parse(cookies[:cart])
        list_items.each do |record|
          cart_item = CartItem.find_by(item_id: record[0].to_i, cart_id: cart.id)
          if cart_item.present?
            cart_item.update_columns(quantity: (cart_item.quantity + record[1].to_i))
          else
            CartItem.create(item_id: record[0].to_i, cart_id: cart.id,
                            quantity: record[1].to_i)
          end
        end
        cookies[:cart] = nil
      end
    end
  end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  protected

  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:email, :password, :password_confirmation, :role])
  end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end

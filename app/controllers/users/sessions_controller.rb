class Users::SessionsController < Devise::SessionsController
# before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  def new
    super
  end

  # POST /resource/sign_in
  def create
    super
    cart = Cart.find_by(user_id: current_user.id)
    unless cart.present?
      cart = Cart.create(user_id: current_user.id)
    end
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

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_in_params
    devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  end
end

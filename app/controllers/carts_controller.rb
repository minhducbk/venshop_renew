class CartsController < ApplicationController
  def create
    item = Item.find_by(id: params[:add_to_cart][:item_id])
    if user_signed_in?
      cart = Cart.find_by(user_id: current_user.id)
      unless cart.present?
        cart = Cart.create(user_id: current_user.id)
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
        end
      end
      CartItem.create(item_id: item.id, cart_id: cart.id,
        quantity: params[:add_to_cart][:quantity])
    else
      list_items = cookies[:cart].present? ? JSON.parse(cookies[:cart]) : {}
      if list_items["#{item.id}"].present?
        list_items["#{item.id}"] += params[:add_to_cart][:quantity].to_i
      else
        list_items["#{item.id}"] = params[:add_to_cart][:quantity].to_i
      end
      cookies[:cart] = {
        :value => list_items.to_json,
        :expires => 4.years.from_now
      }
    end
    redirect_to category_path(item.category.id)
  end

  def show
    @cart_items = []
    if user_signed_in?
      cart = Cart.find_by(user_id: current_user.id)
      @cart_items = cart.cart_items.map{|cart_item|
        [Item.find_by(id: cart_item.item_id), cart_item.quantity]
      }
    else
      cart = cookies[:cart].present? ? JSON.parse(cookies[:cart]) : []
      @cart_items = cart.map{ |record|
        [Item.find_by(id: record[0].to_i), record[1].to_i]
      }
    end
    @count_items = get_quantity(cart)
    @subtotal = get_subtotal(@cart_items)
  end

  def destroy
    if user_signed_in?
      cart = Cart.find_by(user_id: current_user.id)
      CartItem.find_by(item_id: params[:item_id].to_i, cart_id: cart.id).destroy
    else
      list_items = JSON.parse(cookies[:cart])
      list_items.delete("#{params[:item_id]}")
      cookies[:cart] = {
        :value => list_items.to_json,
        :expires => 4.years.from_now
      }
    end
    redirect_to cart_path
  end
end

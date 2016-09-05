class OrdersController < ApplicationController
  def create
    cart = Cart.find_by(user_id: current_user.id)
    order = Order.create(user_id: current_user.id, status: Order.order_statuses[:new_order])
    cart.cart_items.each do|cart_item|
      OrderItem.create(order_id: order.id, item_id: cart_item.item_id,
        quantity: cart_item.quantity)
      item = Item.find_by(id: cart_item.item_id)
      item.update_columns(stock: (item.stock - cart_item.quantity))
    end
    cart.destroy
    Cart.create(user_id: current_user.id)
    MailWorker.perform_async(current_user.email)
    #UserMailer.finish_checkout(current_user).deliver_now
    redirect_to root_path
  end
end

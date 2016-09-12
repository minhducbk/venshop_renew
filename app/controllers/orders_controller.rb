class OrdersController < ApplicationController
  def create
    cart = Cart.find_by(user_id: current_user.id)
    order = Order.create(user_id: current_user.id, status: Order.order_statuses[:New])
    cart.cart_items.each do |cart_item|
      OrderItem.create(order_id: order.id, item_id: cart_item.item_id, quantity: cart_item.quantity)
      item = Item.find_by(id: cart_item.item_id)
      item.update_columns(stock: (item.stock - cart_item.quantity))
    end
    cart.destroy
    Cart.create(user_id: current_user.id)
    # MailWorker.new.perform(current_user.email)

    MailWorker.perform_async(current_user.email)
    # UserMailer.finish_checkout(current_user).deliver_now
    redirect_to orders_path
  end

  def index
    @is_admin = current_user.role == User.role_users[:admin]
    list_orders = @is_admin ? Order.all : Order.where("user_id = ?", current_user.id)
    @list_orders = Kaminari.paginate_array(list_orders)
                           .page(params[:page]).per(10)
  end

  def show
    @is_admin = current_user.role == User.role_users[:admin]
    @order = Order.find_by(id: params[:id])
    @order_items = convert_order_to_array(@order)
    @count_items = get_quantity(@order_items)
    @subtotal = get_subtotal(@order_items)
  end

  def update
    @is_admin = current_user.role == User.role_users[:admin]
    @order = Order.find_by(id: params[:id])
    @order_items = convert_order_to_array(@order)
    @count_items = get_quantity(@order_items)
    @subtotal = get_subtotal(@order_items)
    new_status = [Order.order_statuses[:New], Order.order_statuses[:Prepare],
                  Order.order_statuses[:Shipping], Order.order_statuses[:Done]]
    cancel_status = [Order.order_statuses[:Cancel]]
    if new_status.include?(@order.status) &&
      cancel_status.include?(Order.order_statuses[params[:update_order][:status]])
      after_cancel(@order)
      @order.update_columns(
        status: Order.order_statuses[params[:update_order][:status]]
      )
    elsif new_status.include?(Order.order_statuses[params[:update_order][:status]]) &&
          cancel_status.include?(@order.status)
      if satisfy_new? @order
        @order.update_columns(status: Order.order_statuses[params[:update_order][:status]])
      else
        redirect_to order_path(@order.id), notice: 'Not enough stock to sale'
        return
      end
    else
      @order.update_columns(status: Order.order_statuses[params[:update_order][:status]])
    end
    redirect_to orders_path
  end
end

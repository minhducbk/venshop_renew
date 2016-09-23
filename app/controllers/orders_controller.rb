class OrdersController < ApplicationController

  def create
    order = Order.create(user_id: current_user.id, status: Order.order_statuses[:New])
    order_items = @cart.cart_items.map do |cart_item|
      item = Item.find_by(id: cart_item.item_id)
      item.update_columns(stock: (item.stock - cart_item.quantity))
      order.order_items.build(item_id: cart_item.item_id, quantity: cart_item.quantity)
    end

    order_items.map(&:save)
    @cart.destroy
    Cart.create(user_id: current_user.id)

    MailWorker.perform_async(current_user.email)
    redirect_to orders_path
  end

  def index
    @list_orders = current_user.is_admin? ? Order.all :
                   Order.where("user_id = ?", current_user.id)
    @list_orders = Kaminari.paginate_array(@list_orders)
                           .page(params[:page]).per(Settings.entries_per_page)
  end

  def show
    @order = Order.includes(:order_items).find_by(id: params[:id])
    @order_items = @order.convert_to_array_of_hash
  end

  def update
    @order = Order.includes(:order_items).find_by(id: params[:id])
    @order_items = @order.convert_to_array_of_hash
    update_status = Order.order_statuses[params[:update_order][:status]]
    new_group = Order.order_statuses[:new_group]
    cancel_group = Order.order_statuses[:cancel_group]

    if new_group.include?(@order.status) && cancel_group.include?(update_status)
      @order.after_cancel
      @order.update_columns(status: update_status)
    elsif new_group.include?(update_status) && cancel_group.include?(@order.status)
      if @order.satisfy_convert_to_new_group?
        @order.update_columns(status: update_status)
      else
        return redirect_to order_path(@order.id), notice: 'Not enough stock to sale'
      end
    else
      @order.update_columns(status: update_status)
    end
    redirect_to orders_path
  end
end

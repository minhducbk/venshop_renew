class OrdersController < ApplicationController
  include OrderConcern
  before_filter :check_role_user, only: [:index, :show, :update]

  def create
    order = Order.create(user_id: current_user.id, status: Order.order_statuses[:New])
    cart_items = @cart.cart_items.map do |cart_item|
      item = Item.find_by(id: cart_item.item_id)
      item.update_columns(stock: (item.stock - cart_item.quantity))
      order.cart_items.build(item_id: cart_item.item_id, quantity: cart_item.quantity)
    end

    cart_items.map {|cart_item| cart_item.save}
    @cart.destroy
    Cart.create(user_id: current_user.id)

    MailWorker.perform_async(current_user.email)
    redirect_to orders_path
  end

  def index
    @list_orders = @is_admin ? Order.all : Order.where("user_id = ?", current_user.id)
    @list_orders = Kaminari.paginate_array(@list_orders)
                           .page(params[:page]).per(10)
  end

  def show
    @order = Order.includes(:order_items).find_by(id: params[:id])
    @order_items = convert_order_to_array_of_hash(@order)
  end

  def update
    @order = Order.includes(:order_items).find_by(id: params[:id])
    @order_items = convert_order_to_array_of_hash(@order)
    update_status = Order.order_statuses[params[:update_order][:status]]
    new_status = Order.order_statuses[:new_status]
    cancel_status = Order.order_statuses[:cancel_status]

    if new_status.include?(@order.status) && cancel_status.include?(update_status)
      after_cancel(@order)
      @order.update_columns(status: update_status)
    elsif new_status.include?(update_status) && cancel_status.include?(@order.status)
      if satisfy_convert_to_new_status? @order
        @order.update_columns(status: update_status)
      else
        redirect_to order_path(@order.id), notice: 'Not enough stock to sale'
        return
      end
    else
      @order.update_columns(status: update_status)
    end
    redirect_to orders_path
  end

  private

  def check_role_user
    @is_admin = current_user.role == User.role_users[:admin]
  end
end

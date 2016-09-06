class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :get_categories
  before_action :get_cart
  include CartsHelper
  include OrdersHelper

  private
  def get_categories
    @categories = Category.all
  end

  def get_cart
    if user_signed_in?
      @cart = Cart.find_by(user_id: current_user)
    else
      @cart = cookies[:cart].present? ? JSON.parse(cookies[:cart]) : []
    end
  end
end

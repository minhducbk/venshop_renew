class CategoriesController < ApplicationController
  def index
    @recommended_items = Item.recommended(6)
    @newest_items = Item.newest(4)
  end

  def show
    @category = Category.includes(:items).find_by(id: params[:id])
    @items = @category.items.page(params[:page])
  end
end

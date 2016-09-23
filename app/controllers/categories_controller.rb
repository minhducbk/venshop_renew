class CategoriesController < ApplicationController
  def index
    @recommended_items = Item.last(6)
    @newest_items = Item.last(4)
  end

  def show
    @category = Category.find_by(id: params[:id])
    items = @category.items
    @items = Kaminari.paginate_array(items)
                     .page(params[:page]).per(Settings.entries_per_page)
  end
end

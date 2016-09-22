class ItemsController < ApplicationController
  def new
    @item = Item.new
  end

  def create
    param = item_params
    category = Category.find_by(name: param[:category])
    param[:category_id] = category.id
    param.delete('category')
    @item = Item.new(param)
    if @item.save
      flash.now[:success] = 'Post successful'
      redirect_to category_path(category.id)
    else
      render 'new'
    end
  end

  def show
    @item = Item.find_by(id: params[:id])
  end

  private

  def item_params
    params.require(:post_item).permit(:name, :price, :stock, :category, :description, :picture)
  end
end

class ItemsController < ApplicationController
  def new
    @item = Item.new
  end

  def create
    new_item_param = post_item_params
    category = Category.find_by(name: new_item_param[:category])
    new_item_param[:category_id] = category.id
    new_item_param.delete('category')
    @item = Item.new(new_item_param)

    if @item.save
      flash.now[:success] = 'Post successful'
      redirect_to item_path(@item.id)
    else
      render 'new'
    end
  end

  def show
    @item = Item.find_by(id: params[:id])
  end

  private

  def post_item_params
    params.require(:post_item).permit(:name,
                                      :price,
                                      :stock,
                                      :category,
                                      :description,
                                      :picture
                                      )
  end
end

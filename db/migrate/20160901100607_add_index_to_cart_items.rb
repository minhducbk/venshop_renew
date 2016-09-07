class AddIndexToCartItems < ActiveRecord::Migration
  def change
    add_index :cart_items, :cart_id
    add_index :cart_items, :item_id
  end
end

class AddIndexToItems < ActiveRecord::Migration
  def change
    add_index :items, :category_id
  end
end

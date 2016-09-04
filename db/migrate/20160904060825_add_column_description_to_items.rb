class AddColumnDescriptionToItems < ActiveRecord::Migration
  def change
    add_column :items, :description, :text
  end
end

class AddColumnKeyworkToCategories < ActiveRecord::Migration
  def change
    add_column :categories, :keyword, :string
  end
end

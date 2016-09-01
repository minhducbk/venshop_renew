class AddColumnAmazonIdToItems < ActiveRecord::Migration
  def change
    add_column :items, :amazon_id, :string
  end
end

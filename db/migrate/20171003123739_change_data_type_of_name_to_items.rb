class ChangeDataTypeOfNameToItems < ActiveRecord::Migration
  def up
    change_column :items, :name, :text
	end
	def down
	    # This might cause trouble if you have strings longer
	    # than 255 characters.
	    change_column :items, :name, :string
	end
end

class AddViewsToShoes < ActiveRecord::Migration
  def change
    add_column :shoes, :views, :integer, default: 0
    add_index :shoes, :views
  end
end
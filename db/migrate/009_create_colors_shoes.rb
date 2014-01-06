class CreateColorsShoes < ActiveRecord::Migration
  def change
    create_table :colors_shoes, options: 'engine=MyISAM DEFAULT CHARSET=utf8', id: false do |t|
      t.references :color
      t.references :shoe
    end
    add_index :colors_shoes, :color_id
    add_index :colors_shoes, :shoe_id
    add_index :colors_shoes, [:color_id, :shoe_id]
  end
end
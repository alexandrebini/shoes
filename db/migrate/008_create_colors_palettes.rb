class CreateColorsPalettes < ActiveRecord::Migration
  def change
    create_table :colors_palettes, options: 'engine=MyISAM DEFAULT CHARSET=utf8', id: false do |t|
      t.references :color
      t.references :palette
    end
    add_index :colors_palettes, :color_id
    add_index :colors_palettes, :palette_id
    add_index :colors_palettes, [:color_id, :palette_id]
  end
end
class CreatePalettes < ActiveRecord::Migration
  def change
    create_table :palettes, options: 'engine=MyISAM DEFAULT CHARSET=utf8' do |t|
      t.string :name
      t.string :hex
      t.string :slug
      t.text :matchers
    end
    add_index :palettes, :name
    add_index :palettes, :slug, unique: true
  end
end
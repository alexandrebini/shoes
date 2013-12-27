class CreateShoes < ActiveRecord::Migration
  def change
    create_table :shoes, options: 'engine=MyISAM DEFAULT CHARSET=utf8' do |t|
      t.references :brand
      t.references :store
      t.boolean :available
      t.string :name
      t.string :description
      t.string :slug
      t.timestamps
    end
    add_index :shoes, :available
    add_index :shoes, :brand_id
    add_index :shoes, :name
    add_index :shoes, :slug, unique: true
    add_index :shoes, :store_id
  end
end
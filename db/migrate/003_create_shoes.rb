class CreateShoes < ActiveRecord::Migration
  def change
    create_table :shoes, options: 'engine=MyISAM DEFAULT CHARSET=utf8' do |t|
      t.references :brand
      t.references :category
      t.string :name
      t.text :description
      t.string :slug
      t.string :source_url
      t.datetime :crawled_at
      t.timestamps
    end
    add_index :shoes, :brand_id
    add_index :shoes, :category_id
    add_index :shoes, [:category_id, :brand_id]
    add_index :shoes, :name
    add_index :shoes, :slug, unique: true
    add_index :shoes, :source_url
  end
end
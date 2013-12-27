class CreateBrands < ActiveRecord::Migration
  def change
    create_table :brands, options: 'engine=MyISAM DEFAULT CHARSET=utf8' do |t|
      t.has_attached_file :logo
      t.string :name
      t.string :slug
      t.string :url
      t.timestamps
    end
    add_index :brands, :name
    add_index :brands, :slug, unique: true
  end
end
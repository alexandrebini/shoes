class CreateStores < ActiveRecord::Migration
  def change
    create_table :stores, options: 'engine=MyISAM DEFAULT CHARSET=utf8' do |t|
      t.string :name
      t.string :slug
      t.string :url
      t.string :start_url
      t.string :verification_matcher
      t.has_attached_file :logo
      t.timestamps
    end
    add_index :stores, :name, unique: true
    add_index :stores, :slug, unique: true
  end
end

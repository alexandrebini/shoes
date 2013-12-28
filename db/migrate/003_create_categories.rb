class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories, options: 'engine=MyISAM DEFAULT CHARSET=utf8' do |t|
      t.string :name
      t.string :slug
      t.timestamps
    end
    add_index :categories, :name, unique: true
    add_index :categories, :slug, unique: true
  end
end

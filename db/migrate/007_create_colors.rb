class CreateColors < ActiveRecord::Migration
  def change
    create_table :colors, options: 'engine=MyISAM DEFAULT CHARSET=utf8' do |t|
      t.string :name
      t.string :slug
    end
    add_index :colors, :name
    add_index :colors, :slug, unique: true
  end
end
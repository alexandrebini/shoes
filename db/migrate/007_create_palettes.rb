class CreatePalettes < ActiveRecord::Migration
  def change
    create_table :palettes, options: 'engine=MyISAM DEFAULT CHARSET=utf8' do |t|
      t.string :name
      t.string :hex
    end
    add_index :palettes, :name
  end
end
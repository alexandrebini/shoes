class CreateNumerations < ActiveRecord::Migration
  def change
    create_table :numerations, options: 'engine=MyISAM DEFAULT CHARSET=utf8' do |t|
      t.references :shoe
      t.integer :number
    end
    add_index :numerations, :shoe_id
    add_index :numerations, :number
    add_index :numerations, [:shoe_id, :number]
  end
end
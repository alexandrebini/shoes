class CreatePrices < ActiveRecord::Migration
  def change
    create_table :prices, options: 'engine=MyISAM DEFAULT CHARSET=utf8' do |t|
      t.references :shoe
      t.integer :value
      t.datetime :created_at
    end
    add_index :prices, :shoe_id
    add_index :prices, :value
    add_index :prices, :created_at
    add_index :prices, [:shoe_id, :created_at]
  end
end
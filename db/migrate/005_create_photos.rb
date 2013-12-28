class CreatePhotos < ActiveRecord::Migration
  def change
    create_table :photos, options: 'engine=MyISAM DEFAULT CHARSET=utf8' do |t|
      t.references :shoe
      t.boolean :main
      t.string :source_url
      t.string :status, default: 'pending'
      t.string :data_file_name
      t.string :data_content_type
      t.string :data_file_size
      t.text :data_meta
      t.string :data_fingerprint
      t.timestamps
    end
    add_index :photos, :status
    add_index :photos, :shoe_id
    add_index :photos, :main
    add_index :photos, :source_url
    add_index :photos, [:shoe_id, :main]
    add_index :photos, [:shoe_id, :status]
  end
end
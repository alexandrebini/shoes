class AddMetaDescriptionToCategory < ActiveRecord::Migration
  def self.up
    add_column :categories, :meta_description, :text
  end

  def self.down
    remove_column :categories, :meta_description
  end
end
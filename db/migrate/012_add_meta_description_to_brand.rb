class AddMetaDescriptionToBrand < ActiveRecord::Migration
  def self.up
    add_column :brands, :meta_description, :string
  end

  def self.down
    remove_column :brands, :meta_description
  end
end
class RenameImageUrlColumnToUsers < ActiveRecord::Migration[6.1]
  def change
    rename_column :users, :image_url, :avatar
  end
end

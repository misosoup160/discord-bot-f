# frozen_string_literal: true

class AddOwnerToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :owner, :boolean, default: false, null: false
  end
end

# frozen_string_literal: true

class AddPostedToAnswers < ActiveRecord::Migration[6.1]
  def change
    add_column :answers, :posted, :boolean, default: false, null: false
  end
end

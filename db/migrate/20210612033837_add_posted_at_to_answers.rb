# frozen_string_literal: true

class AddPostedAtToAnswers < ActiveRecord::Migration[6.1]
  def change
    add_column :answers, :posted_at, :datetime
  end
end

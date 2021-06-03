# frozen_string_literal: true

class Question < ApplicationRecord
  validates :body, length: { maximum: 200 }, presence: true
end

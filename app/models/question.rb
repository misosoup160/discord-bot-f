# frozen_string_literal: true

class Question < ApplicationRecord
  has_many :answers

  validates :body, length: { maximum: 200 }, presence: true
end

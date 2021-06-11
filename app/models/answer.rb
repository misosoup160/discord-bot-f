# frozen_string_literal: true

class Answer < ApplicationRecord
  belongs_to :user
  belongs_to :question

  validates :body, length: { maximum: 2000 }, presence: true

  def self.search(keyword)
    if keyword
      Answer.eager_load(:question, :user).where('answers.body like ?', "%#{keyword}%")
            .or(Answer.eager_load(:question, :user).where('questions.body like ?', "%#{keyword}%"))
            .or(Answer.eager_load(:question, :user).where("concat_ws('#', users.name, users.discriminator) like ?", "%#{keyword}%"))
    else
      Answer.all
    end
  end
end

# frozen_string_literal: true

module AnswersHelper
  def posted_or_not(answer)
    answer.posted ? 'is-posted' : ''
  end
end

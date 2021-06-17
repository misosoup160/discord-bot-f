# frozen_string_literal: true

require 'test_helper'

class AnswerTest < ActiveSupport::TestCase
  test '#answers_search' do
    answer = answers(:one)
    assert_equal answer, Answer.search('焼肉定食').first
  end
end

# frozen_string_literal: true

require 'test_helper'

class AnswerTest < ActiveSupport::TestCase
  test '.search' do
    assert_equal answers(:one), Answer.search('焼肉定食').first
    assert_equal answers(:three), Answer.search('bob').first
    assert_equal answers(:three), Answer.search('食べ物').first
    assert_equal 3, Answer.search('').count
    assert_equal nil, Answer.search('%').first
  end
end
